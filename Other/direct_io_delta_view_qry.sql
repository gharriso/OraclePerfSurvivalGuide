col wait_time format a30
col total_waits format 99,999
col time_waited_ms format 999,999.99 
col pct_time format 99.99 
sol sample_seconds format 9,999 heading "Sample|Secs"
set pagesize 1000
set lines 100
set echo on 

SELECT * FROM direct_io_delta_view;

