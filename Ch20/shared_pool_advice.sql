rem *********************************************************** 
rem
rem	File: shared_pool_advice.sql 
rem	Description: Shared pool advisory
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 605
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 



col shared_pool_size_for_estimate format 99,999 heading "Shared Pool|MB"
col size_pct format 999 heading "Size Pct|Current"
col estd_lc_time_saved format 999,999,999 heading "Time Saved|(s)"
col saved_pct format 999.99 heading "Relative|Time Saved(%)"
col estd_lc_load_time format 999,999,999 heading "Load/Parse|Time (s)"
col  load_pct heading "Relative|Time (%)"
set pages 1000
set lines 100
set echo on 
        
SELECT shared_pool_size_for_estimate,
       shared_pool_size_factor * 100 size_pct,
       estd_lc_time_saved, 
       estd_lc_time_saved_factor * 100 saved_pct,
       estd_lc_load_time, 
       estd_lc_load_time_factor * 100 load_pct
FROM v$shared_pool_advice
ORDER BY shared_pool_size_for_estimate;

 
