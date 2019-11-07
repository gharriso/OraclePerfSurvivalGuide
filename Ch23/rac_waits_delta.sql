rem *********************************************************** 
rem
rem	File: rac_waits_delta.sql 
rem	Description: RAC waits over an interval of time 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 671
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col wait_type format a25 heading "Wait Type"
col sample_secs format 999,999 heading "Sample|Secs"
col waits_ps format 99,999.99 heading "Waits|/Sec"
col ms_ps format 99,999.99 heading "Ms|/Sec"
col avg_ms format 9,999.99 heading "Avg|Ms"
col pct_time format 99.99 heading "Pct|Time"

set pagesize 1000
set lines 80
set echo on 

SELECT * FROM rac_wait_delta_view ;
