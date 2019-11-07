/* Formatted on 2008/07/08 17:03 (Formatter Plus v4.8.7) */
SELECT NAME, total_waits, time_waited_micro,
       ROUND (time_waited_micro * 100 / SUM (time_waited_micro) OVER (),
              2
             ) pct_total_time,
       ROUND (waits_per_second, 2) waits_per_second,
       ROUND (microseconds_per_second, 2) micro_per_second,
       ROUND (  microseconds_per_second
              * 100
              / SUM (microseconds_per_second) OVER (),
              2
             ) pct_micro_in_interval,
        case when waits_per_second>0 then round(microseconds_per_second/waits_per_second,2) else null end as  avg_micro_in_interval
  FROM TABLE (opsg_time_model (5))

