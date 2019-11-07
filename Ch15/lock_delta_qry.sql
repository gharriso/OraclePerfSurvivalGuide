rem *********************************************************** 
rem
rem	File: lock_delta_qry.sql 
rem	Description: Show lock waits compared to other waits and CPU over a short time period 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 467
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column wait_type format a35
set pagesize 1000
set echo on


SELECT wait_type, time_waited_ms, pct_time, sample_seconds
  FROM lock_delta_view
 WHERE pct_time > 1; 
 
