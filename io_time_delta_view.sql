CREATE OR REPLACE VIEW io_time_delta_view AS
   WITH delta_times AS (
        SELECT CASE
                  WHEN wait_class IN ('User I/O', 'System I/O') THEN stat_name
                  WHEN wait_class IS NULL THEN stat_name
                  ELSE wait_class
               END
                  AS wait_type, e.*
        FROM    opsg_delta_report e
             LEFT OUTER JOIN
                v$event_name
             ON (stat_name = name)
        WHERE  NVL(wait_class,'na')  <> 'Idle'   )
   SELECT sample_seconds, wait_type, SUM(total_waits) total_waits,
          ROUND(SUM(time_waited_micro) / 1000000, 2) time_waited_seconds,
          ROUND(SUM(time_waited_micro) * 100 / 
          SUM(SUM(time_waited_micro)) OVER (), 2) pct,
          CASE
             WHEN SUM(total_waits) > 0 THEN
                ROUND(SUM(time_waited_micro) / 1000 /SUM(total_waits), 2)
          END
             avg_time_ms
   FROM delta_times
   GROUP BY sample_seconds, wait_type
   ORDER BY 4 DESC
/
