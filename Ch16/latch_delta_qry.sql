rem *********************************************************** 
rem
rem	File: latch_delta_qry.sql 
rem	Description: Latch/mutex waits over a short duration compared to other waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 495
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column wait_type format a35
column pct_time format 99.00
set pagesize 1000
set echo on


SELECT wait_type, time_waited_ms, pct_time, sample_seconds
  FROM latch_delta_view
 WHERE pct_time > .01; 
 
