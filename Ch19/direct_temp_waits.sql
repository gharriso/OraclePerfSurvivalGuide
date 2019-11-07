rem *********************************************************** 
rem
rem	File: direct_temp_waits.sql 
rem	Description: temporary direct path IO compared to CPU and other non-idle waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 566
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column wait_type format a35
column lock_name format a12
column total_waits format  999,999,999
column time_waited_seconds format 999,999.99
column pct format 99.99
set pagesize 10000
set lines 100
set echo on 

WITH system_event AS 
  (SELECT CASE WHEN event LIKE   'direct path%temp'
              THEN event  ELSE wait_class
          END wait_type, e.*
     FROM v$system_event e)
SELECT wait_type,SUM(total_waits) total_waits,
       round(SUM(time_waited_micro)/1000000,2) time_waited_seconds,
       ROUND(  SUM(time_waited_micro)
             * 100
             / SUM(SUM(time_waited_micro)) OVER (), 2) pct
FROM (SELECT  wait_type, event, total_waits, time_waited_micro
      FROM    system_event e
      UNION
      SELECT   'CPU', stat_name, NULL, VALUE
      FROM v$sys_time_model
      WHERE stat_name IN ('background cpu time', 'DB CPU')) l
WHERE wait_type <> 'Idle'
GROUP BY wait_type 
ORDER BY 4 DESC; 

 
