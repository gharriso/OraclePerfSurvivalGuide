CREATE OR REPLACE VIEW hit_rate_delta_view AS
   WITH sysstats AS
          (SELECT (end_timestamp - start_timestamp) * 25 * 3600
                     interval_seconds,
                  CASE
                     WHEN name LIKE '%direct' THEN 'Direct'
                     WHEN name LIKE '%cache' THEN 'Cache'
                     ELSE 'All'
                  END
                     AS category,
                  CASE
                     WHEN name LIKE 'consistent%' THEN 'Consistent'
                     WHEN name LIKE 'db block%' THEN 'db block'
                     ELSE 'physical'
                  END
                     AS TYPE, VALUE
           FROM table(opsg_pkg.sysstat_report())
           WHERE name IN
                       ('consistent gets',
                        'consistent gets direct',
                        'consistent gets from cache',
                        'db block gets',
                        'db block gets direct',
                        'db block gets from cache',
                        'physical reads',
                        'physical reads cache',
                        'physical reads direct'))
   SELECT ROUND(interval_seconds) sample_seconds, category, db_block,
          consistent, physical,
          ROUND(DECODE(category, 'Direct', NULL,
                  ((db_block + consistent) - physical)
                * 100
                / (db_block + consistent)), 2)
             AS hit_rate
   FROM (SELECT interval_seconds, category,
                SUM(DECODE(TYPE, 'db block', VALUE)) db_block,
                SUM(DECODE(TYPE, 'Consistent', VALUE)) consistent,
                SUM(DECODE(TYPE, 'physical', VALUE)) physical
         FROM sysstats
         GROUP BY interval_seconds, category)
   ORDER BY category DESC
/

/* Formatted on 24/02/2009 7:41:53 PM (QP5 v5.120.811.25008) */
