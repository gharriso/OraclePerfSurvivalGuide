/* Formatted on 2008/07/23 15:12 (Formatter Plus v4.8.7) */
SELECT  sample_seconds,nvl(wait_class,stat_name) stat, sum(total_waits) waits, sum(time_waited_micro) micro 
  FROM opsg_delta_report left outer join v$event_name  on (stat_name=name)
  group by sample_seconds,nvl(wait_class,stat_name)
 order by 2

 

