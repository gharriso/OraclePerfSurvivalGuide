rem *********************************************************** 
rem
rem	File: sga_resize_ops.sql 
rem	Description: Query on V$SGA_RESIZE_OPS
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 551
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 100
col initial_mb format 9,999 heading "Initial|MB"
col final_mb format 9,999 heading "Final|MB"
column component format a24
set echo on

SELECT TO_CHAR(end_time, 'HH24:MI') end_time, component, 
       oper_type, oper_mode,
       ROUND(initial_size / 1048576) initial_mb,
       ROUND(final_size / 1048576) final_mb, status
FROM v$sga_resize_ops o
WHERE end_time > SYSDATE - NUMTODSINTERVAL(24, 'HOUR')
ORDER BY end_time DESC;
 
