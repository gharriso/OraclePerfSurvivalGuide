/* Formatted on 2008/07/23 15:12 (Formatter Plus v4.8.7) */
SELECT sample_seconds, stat_name, waits_per_second waits_per_sec,
       ms_per_second ms_per_sec, pct_of_time pct
  FROM opsg_delta_report
 WHERE ms_per_second>0

