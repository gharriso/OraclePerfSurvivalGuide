rem *********************************************************** 
rem
rem	File: io_waits_delta.sql 
rem	Description: IO waits reported for an interval 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 618
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col sample_seconds format 9,999 heading "Sample|Secs"
col total_waits format 99,999,999 heading "Total|Waits"
col time_waited_seconds format 99,999,999.99 heading "time|Waited (s)"
col avg_time_ms format 99,999.99 heading "Avg|Time (ms)"
col wait_type format a28 heading "Wait Type"
col pct format 99.99
set lines 80
set pages 1000
set echo on

SELECT sample_seconds, wait_type, total_waits, time_waited_seconds,
       avg_time_ms, pct
  FROM io_time_delta_view
 WHERE pct > .1
 ORDER BY time_waited_seconds DESC;
 
