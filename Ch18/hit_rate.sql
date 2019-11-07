rem *********************************************************** 
rem
rem	File: hit_rate.sql 
rem	Description: """hit rates"" for direct and cached IOs "
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 541
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 80
column category format a12 heading "Category"
column db_block format 99,999,999 heading "DB Block|Gets"
column consistent format 99,999,999 heading "Consistent|Gets"
column physical format 99,999,999 heading "Physical|Gets"
column  hit_rate format 99.99 heading "Hit|Rate"
set echo on 

WITH sysstats AS
    (SELECT CASE WHEN name LIKE '%direct' THEN 'Direct'
                 WHEN name LIKE '%cache' THEN 'Cache'
                  ELSE 'All' END AS category,
            CASE WHEN name LIKE 'consistent%' THEN 'Consistent'
                 WHEN name LIKE 'db block%' THEN 'db block'
                 ELSE 'physical' END AS TYPE, VALUE
       FROM v$sysstat
      WHERE name IN ('consistent gets','consistent gets direct',
                     'consistent gets from cache','db block gets',
                     'db block gets direct', 'db block gets from cache',
                     'physical reads', 'physical reads cache',
                     'physical reads direct'))
SELECT category, db_block, consistent, physical,
       ROUND(DECODE(category,'Direct', NULL,
                ((db_block + consistent) - physical)* 100
                    / (db_block + consistent)), 2) AS hit_rate
FROM (SELECT category, SUM(DECODE(TYPE, 'db block', VALUE)) db_block,
             SUM(DECODE(TYPE, 'Consistent', VALUE)) consistent,
             SUM(DECODE(TYPE, 'physical', VALUE)) physical
      FROM sysstats
      GROUP BY category)
ORDER BY category DESC
/
