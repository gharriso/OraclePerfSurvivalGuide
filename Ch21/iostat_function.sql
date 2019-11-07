rem *********************************************************** 
rem
rem	File: iostat_function.sql 
rem	Description: Summary report of v$iostat_function 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 620
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col function_name format a25 heading "File Type"
col reads format 99,999,999 heading "Reads"
col writes format 99,999,999 heading "Writes"
col number_of_waits format 99,999,999 heading "Waits" 
col wait_time_sec format 999,999,999 heading "Wait Time|Sec"
col avg_wait_ms format 999.99 heading "Avg|Wait ms"
set lines 80
set pages 10000
set echo on

SELECT function_name, small_read_reqs + large_read_reqs reads,
       small_write_reqs + large_write_reqs writes, 
       wait_time/1000 wait_time_sec,
       CASE WHEN number_of_waits > 0 THEN 
          ROUND(wait_time / number_of_waits, 2)
       END avg_wait_ms
  FROM v$iostat_function
 ORDER BY wait_time DESC;

