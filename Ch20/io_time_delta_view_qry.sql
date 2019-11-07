rem *********************************************************** 
rem
rem	File: io_time_delta_view_qry.sql 
rem	Description: IO wait breakdown over a time period 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 581
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col sample_seconds format 999,999 heading "Sample|Seconds"
col wait_type format a35 heading "Wait Category"
col total_waits format 99,999,999 heading "Total Waits"
col time_waited_seconds format 99,999,999.99 heading "Time Waited|Seconds"
col pct format 999.99 heading "Time|Pct"
set echo on

SELECT sample_seconds, wait_type, total_waits, time_waited_seconds, pct
FROM io_time_delta_view
ORDER BY pct DESC;
 
