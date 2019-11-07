rem *********************************************************** 
rem
rem	File: pga_target_time.sql 
rem	Description: PGA target converted to elapsed times 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 583
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col current_size_mb format 99,999 heading "Current|MB"
col pga_target_mb format 99,999 heading "Target|MB"
col estd_seconds_delta format 99,999,999.99 heading "Estimated|time delta (s)"
col estd_extra_mb_rw format 99,999,999 heading "Estimated|extra MB"
set pagesize 1000
set lines 75 
set echo on 

SELECT current_size / 1048576 current_size_mb,
       pga_target_for_estimate / 1048576 pga_target_mb,
       (estd_extra_bytes_rw - current_extra_bytes_rw)
          * 0.1279 / 1000000 AS estd_seconds_delta, 
       estd_extra_bytes_rw / 1048576 estd_extra_mb_rw
FROM v$pga_target_advice, 
     (SELECT pga_target_for_estimate current_size,
             estd_extra_bytes_rw current_extra_bytes_rw
        FROM v$pga_target_advice
       WHERE pga_target_factor = 1);

