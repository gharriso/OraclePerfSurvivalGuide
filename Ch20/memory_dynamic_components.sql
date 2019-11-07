rem *********************************************************** 
rem
rem	File: memory_dynamic_components.sql 
rem	Description: V$MEMORY_DYNAMIC_COMPONENTS report 
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


col component format a24
col current_mb format 99,999 heading "Current|MB"
col min_mb  format 99,9999 heading "Min|MB"
col max_mb format 99,9999 heading "Max|MB"
col user_spec_mb format 99,9999 heading "User|set MB"
col last_oper_type format a8 heading "Last|Resize"
set pagesize 1000
set lines 75
set echo on 
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF current_mb ON REPORT

SELECT component, ROUND(current_size / 1048576) current_mb,
       ROUND(min_size / 1045876) min_mb, 
       ROUND(max_size / 1045876) max_mb,
       ROUND(user_specified_size / 1048576) user_spec_mb, 
       last_oper_type
FROM V$MEMORY_DYNAMIC_COMPONENTS; 
