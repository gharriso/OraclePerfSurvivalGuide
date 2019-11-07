rem *********************************************************** 
rem
rem	File: direct_io_delta_view_qry.sql 
rem	Description: Direct path temp IO over a time interval 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 567
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col wait_type format a30
col total_waits format 99,999
col time_waited_ms format 999,999.99 
col pct_time format 99.99 
col sample_seconds format 9,999 heading "Sample|Secs"
set pagesize 1000
set lines 100
set echo on 

SELECT * FROM direct_io_delta_view;

