rem *********************************************************** 
rem
rem	File: timeModelSimple.sql 
rem	Description: Time model unioned with wait data to show waits combined with CPU timings 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 3 Page 73
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set lines 100
set pages 10000
set echo on 
column total_waits format  999999999


SELECT   event, total_waits,
         ROUND (time_waited_micro / 1000000) AS time_waited_secs,
         ROUND (time_waited_micro * 100 / 
            SUM (time_waited_micro) OVER (),2) AS pct_time
    FROM (SELECT event, total_waits, time_waited_micro
            FROM v$system_event
           WHERE wait_class <> 'Idle'
          UNION
          SELECT stat_name, NULL, VALUE
            FROM v$sys_time_model
           WHERE stat_name IN ('DB CPU', 'background cpu time'))
ORDER BY 3 DESC; 

