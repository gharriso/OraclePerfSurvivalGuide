create or replace view lock_delta_view as 
WITH wait_times AS 
  (SELECT CASE
            WHEN stat_name LIKE 'enq: %' THEN stat_name
            WHEN wait_class IS NULL THEN stat_name
            ELSE wait_class
          END wait_type,
         (end_timestamp - start_timestamp) * 24 * 3600 sample_seconds,
         total_waits, time_waited_micro / 1000 time_waited_ms
      FROM  TABLE(opsg_pkg.wait_time_report()) r
            LEFT OUTER JOIN v$event_name e
              ON (name = stat_name))
SELECT wait_type, SUM(total_waits) total_waits,
       SUM(time_waited_ms) time_waited_ms,
       round(sum(time_waited_ms)*100/sum(sum(time_waited_ms))   over()) pct_time,
       ROUND(MAX(sample_seconds)) sample_seconds
FROM wait_times
GROUP BY wait_Type
ORDER BY 3 DESC

