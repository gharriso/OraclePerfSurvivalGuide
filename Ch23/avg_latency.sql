rem *********************************************************** 
rem
rem	File: avg_latency.sql 
rem	Description: Global cache latency report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 673
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col event format a30 heading "Wait event"
col total_waits format 999,999,999 heading "Total|Waits"
col time_waited_secs format  999,999,999 heading "Time|(secs)"
col avg_ms format 9,999.99 heading "Avg Wait|(ms)"
set pagesize 1000
set lines 80
set echo on

SELECT event, SUM(total_waits) total_waits,
       ROUND(SUM(time_waited_micro) / 1000000, 2) time_waited_secs,
       ROUND(SUM(time_waited_micro) / 1000 / SUM(total_waits), 2) avg_ms
FROM gv$system_event
WHERE    event LIKE 'gc%block%way'
      OR event LIKE 'gc%multi%'
      OR event LIKE 'gc%grant%'
      OR event = 'db file sequential read'
GROUP BY event
HAVING SUM(total_waits) > 0
ORDER BY event;
