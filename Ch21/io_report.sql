SELECT total_waits / sample_seconds rate,
       (time_waited_micro / total_waits/1000) avg_io_time_ms, waits_per_second
FROM io_wait_log
WHERE sample_seconds < 100 AND total_waits / sample_seconds > 2
ORDER BY end_timestamp
/* Formatted on 20-Mar-2009 23:15:23 (QP5 v5.120.811.25008) */
