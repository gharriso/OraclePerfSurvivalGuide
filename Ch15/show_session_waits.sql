rem *********************************************************** 
rem
rem	File: show_session_waits.sql 
rem	Description: Blocking row level locks at the session level 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 477
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column sid format 9999 heading "Blocked|SID"
column event format a35 heading "Wait event"
column object format a40 heading "Object Type: name"
column sql_text format a70 heading "SQL Text" 
column blocking_session format 999 heading "Blocking|SID"
column time_ms format 999,999.99 heading "MS|Waited"

set pagesize 1000
set lines 80
set echo on 

SELECT sid, event, wait_time_micro / 1000 time_ms, blocking_session,
       object_type || ': ' || object_name object, sql_text 
  FROM v$session s 
  LEFT OUTER JOIN v$sql
       USING (sql_id)
  LEFT OUTER JOIN dba_objects
       ON (object_id = row_wait_obj#)
WHERE event LIKE 'enq: %';

