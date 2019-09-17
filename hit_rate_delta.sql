set pages 1000
set lines 80
column category format a12 heading "Category"
column db_block format 99,999,999 heading "DB Block|Gets"
column consistent format 99,999,999 heading "Consistent|Gets"
column physical format 99,999,999 heading "Physical|Gets"
column  hit_rate format 99.99 heading "Hit|Rate"
set echo on 

WITH sysstats AS
    (SELECT (end_timestamp-start_timestamp)*25*3600 interval_seconds,
            CASE WHEN name LIKE '%direct' THEN 'Direct'
                 WHEN name LIKE '%cache' THEN 'Cache'
                  ELSE 'All' END AS category,
            CASE WHEN name LIKE 'consistent%' THEN 'Consistent'
                 WHEN name LIKE 'db block%' THEN 'db block'
                 ELSE 'physical' END AS TYPE, VALUE
       FROM  table(opsg_pkg.sysstat_report()) 
      WHERE name IN ('consistent gets','consistent gets direct',
                     'consistent gets from cache','db block gets',
                     'db block gets direct', 'db block gets from cache',
                     'physical reads', 'physical reads cache',
                     'physical reads direct'))
SELECT round(interval_seconds) sample_seconds,category, db_block, consistent, physical,
       ROUND(DECODE(category,'Direct', NULL,
                ((db_block + consistent) - physical)* 100
                    / (db_block + consistent)), 2) AS hit_rate
FROM (SELECT interval_seconds,category, SUM(DECODE(TYPE, 'db block', VALUE)) db_block,
             SUM(DECODE(TYPE, 'Consistent', VALUE)) consistent,
             SUM(DECODE(TYPE, 'physical', VALUE)) physical
      FROM sysstats
      GROUP BY interval_seconds,category)
ORDER BY category DESC
/
