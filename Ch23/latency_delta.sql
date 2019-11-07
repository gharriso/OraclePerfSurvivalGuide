rem *********************************************************** 
rem
rem	File: latency_delta.sql 
rem	Description: Global cache latency over a time period
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 674
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col sample_seconds format 9,999 heading "Sample|Secs"
col stat_name format a30 heading "Wait Type"
col waits_per_second format 99,999.99 heading "Waits|\sec"
col avg_ms format  99,999.99 heading "Avg|ms"
set pages 1000
set lines 80
set echo on 


SELECT ROUND((end_timestamp - start_timestamp) * 24 * 3600) 
            sample_seconds,
       stat_name, round(waits_per_second,2) waits_per_second,
       ROUND(microseconds_per_second/1000/waits_per_second,2) avg_ms
FROM table(opsg_pkg.rac_wait_time_report())
WHERE  (  stat_name LIKE 'gc%block%way'
      OR stat_name LIKE 'gc%multi%'
      OR stat_name LIKE 'gc%grant%'
      OR stat_name = 'db file sequential read')
and waits_per_second >0  
ORDER BY stat_name ; 
