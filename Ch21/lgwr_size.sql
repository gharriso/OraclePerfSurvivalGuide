rem *********************************************************** 
rem
rem	File: lgwr_size.sql 
rem	Description: Size of an average redo log IO 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 634
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col total_mb format 999,999,999
col total_requests format 999,999,999,999
col avg_write_kb format 99,999.99
set pagesize 1000
set lines 70
set echo on 

SELECT (small_write_megabytes + large_write_megabytes) total_mb,
       (small_write_reqs + large_write_reqs) total_requests,
         ROUND((small_write_megabytes + large_write_megabytes)
       * 1024
       / (small_write_reqs + large_write_reqs),2)
          avg_write_kb
FROM v$iostat_function
WHERE function_name = 'LGWR'; 
