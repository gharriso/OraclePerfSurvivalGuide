CREATE OR REPLACE VIEW rac_wait_delta_view AS
WITH waits AS (
    SELECT CASE n.wait_class
               WHEN 'Cluster' THEN stat_name
               WHEN NULL THEN stat_name
               ELSE wait_class
           END wait_type,
           ROUND((end_timestamp - start_timestamp) * 24 * 3600) sample_seconds,
           stat_name,  waits_per_second  ,
           microseconds_per_second micro_ps
    FROM     table(opsg_pkg.rac_wait_time_report()) s
         LEFT OUTER JOIN
             sys.v_$event_name n
         ON (s.stat_name = n.name)
    WHERE waits_per_second > 0)
SELECT MAX(sample_seconds) sample_secs,wait_type, 
       ROUND(SUM(waits_per_second),2) waits_ps, 
       ROUND(SUM(micro_ps)/1000,2) ms_ps,
       ROUND(SUM(micro_ps)/1000/SUM(waits_per_second),2) avg_ms, 
       ROUND(SUM(micro_ps)*100/SUM(SUM(micro_ps)) OVER(),2) pct_time
  FROM waits
 GROUP BY wait_type
 ORDER BY SUM(micro_ps) DESC 
