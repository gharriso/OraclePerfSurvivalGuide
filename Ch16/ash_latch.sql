rem *********************************************************** 
rem
rem	File: ash_latch.sql 
rem	Description: Latch statistics from Active Session History (ASH) 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 497
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column event format a20
column program format a10
column username format a8
column module format a12
column object_name format a12
column time_ms format 9,999,999
column pct_of_time format 999.00
column sql_text format a70
column lock_type format a4 

set pages 1000
set lines 100
set echo on 
 
WITH ash_query AS (
     SELECT event, program, 
            h.module, h.action,   object_name,
            SUM(time_waited)/1000 time_ms, COUNT( * ) waits, 
            username, sql_text,
            RANK() OVER (ORDER BY SUM(time_waited) DESC) AS time_rank,
            ROUND(SUM(time_waited) * 100 / SUM(SUM(time_waited)) 
                OVER (), 2)             pct_of_time
      FROM  v$active_session_history h 
      JOIN  dba_users u  USING (user_id)
      LEFT OUTER JOIN dba_objects o
           ON (o.object_id = h.current_obj#)
      LEFT OUTER JOIN v$sql s USING (sql_id)
     WHERE event LIKE '%latch%' or event like '%mutex%'
     GROUP BY event,program, h.module, h.action, 
         object_name,  sql_text, username)
SELECT event,module, username,  object_name, time_ms,pct_of_time,
         sql_text
FROM ash_query
WHERE time_rank < 11
ORDER BY time_rank; 
 
