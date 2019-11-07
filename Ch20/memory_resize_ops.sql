rem *********************************************************** 
rem
rem	File: memory_resize_ops.sql 
rem	Description: V$MEMORY_RESIZE_OPS report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 590
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col component format a20 
col oper_type format a10
col initial_mb format 99,999
col target_mb format 99,999
col end_time format a5 heading "End|Time"
set pagesize 1000
set lines 70
set echo on 

SELECT component, oper_type, 
       initial_size / 1048576 initial_mb,
       target_size / 1048576 target_mb,
       to_char(end_time,'HH24:MI') end_time 
FROM v$memory_resize_ops
WHERE end_time > SYSDATE - NUMTODSINTERVAL(1, 'HOUR')
ORDER BY start_time DESC; 
