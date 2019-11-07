rem *********************************************************** 
rem
rem	File: log_file_waits.sql 
rem	Description: Report of redo log related waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 636
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column wait_type format a35 heading "Wait Type"
column lock_name format a12
column waits_1000 format  99,999,999 heading "Waits|\1000"
column time_waited_hours format 99,999.99 heading "Time|Hours"
column pct format 99.99 Heading "Pct"
column avg_wait_ms format 9,999.99 heading "Avg Wait|Ms"
set pagesize 10000
set lines 100
set echo on

WITH system_event AS 
    (SELECT CASE
              WHEN event LIKE 'log file%'
              THEN event ELSE wait_class
             END  wait_type, e.*
        FROM v$system_event e)
SELECT wait_type, SUM(total_waits) / 1000 waits_1000,
       ROUND(SUM(time_waited_micro) / 1000000 / 3600, 2) 
             time_waited_hours,
       ROUND(SUM(time_waited_micro) / SUM(total_waits) / 1000, 2)
             avg_wait_ms,
       ROUND(  SUM(time_waited_micro)
             * 100
             / SUM(SUM(time_waited_micro)) OVER (), 2)
          pct
FROM (SELECT wait_type, event, total_waits, time_waited_micro
      FROM system_event e
      UNION
      SELECT 'CPU', stat_name, NULL, VALUE
      FROM v$sys_time_model
      WHERE stat_name IN ('background cpu time', 'DB CPU')) l
WHERE wait_type <> 'Idle'
GROUP BY wait_type
ORDER BY SUM(time_waited_micro) DESC
/

/* Formatted on 21/03/2009 9:21:23 AM (QP5 v5.120.811.25008) */
