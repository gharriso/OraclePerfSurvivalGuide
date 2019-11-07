rem *********************************************************** 
rem
rem	File: memory_target_advice.sql 
rem	Description: Memory target advice report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 591
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col memory_size format 99,999 heading "Memory|Size MB"
col memory_size_pct format 999.99 heading "Memory|Pct of Current"
col estd_db_time_pct format 9,999.99 heading "Relative|DB Time"
col estd_db_time format 99,999,999 heading "Estimated|DB Time"
set pagesize 1000
set lines 75 
set echo on 

SELECT memory_size, memory_size_factor * 100 memory_size_pct,
       estd_db_time_factor * 100 estd_db_time_pct,
       estd_db_time
FROM v$memory_target_advice a
ORDER BY memory_size_factor
/
