rem *********************************************************** 
rem
rem	File: session_lock_waits.sql 
rem	Description: Show sessions with a specific USERNAME and their lock waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 472
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

WITH session_event AS 
  (SELECT CASE WHEN event LIKE 'enq:%' 
              THEN event  ELSE wait_class
          END wait_type, e.*
     FROM v$session_event e   )
SELECT  wait_type,SUM(total_waits) total_waits,
       round(SUM(time_waited_micro)/1000000,2) time_waited_seconds,
       ROUND(  SUM(time_waited_micro)
             * 100
             / SUM(SUM(time_waited_micro)) OVER (), 2) pct
FROM (SELECT  e.sid, wait_type, event, total_waits, time_waited_micro
      FROM    session_event e
      UNION
      SELECT  sid, 'CPU', stat_name, NULL, VALUE
      FROM v$sess_time_model
      WHERE stat_name IN ('background cpu time', 'DB CPU')) l
WHERE wait_type <> 'Idle'
 and sid in (select sid from v$session where username='OPSG') 
GROUP BY wait_type 
ORDER BY 4 DESC
/
