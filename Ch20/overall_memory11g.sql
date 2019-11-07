rem *********************************************************** 
rem
rem	File: overall_memory11g.sql 
rem	Description: Combined (PGA+SGA) memory advice report for 11g 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 586
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col buffer_cache format a16 heading "Buffer Cache|Change"
col pga format a12 heading "PGA |Change"
col current_cache_mb format 99,999 heading "Current|Cache MB"
col target_cache_mb format 99,999 heading "Target|Cache MB"
col current_pga_mb format 99,999 heading "Current|PGA MB"
col target_pga_mb format 99,999 heading "Target|PGA MB"
col pga_secs_delta format 99,999,999 heading "Pga Time|Delta (s)"
col cache_secs_delta format 99,999,999 heading "Cache Time|Delta (s)"
col total_secs_delta format 99,999,999 heading "Total Time|Delta (s)"

set pagesize 1000
set lines 80
set echo on 
        
WITH db_cache_times AS 
    (SELECT current_size current_cache_mb, 
            size_for_estimate target_cache_mb,
            (estd_physical_read_time - current_time) 
               cache_secs_delta
       FROM v$db_cache_advice,
            (SELECT size_for_estimate current_size,
                    estd_physical_read_time current_time
               FROM v$db_cache_advice
              WHERE  size_factor = 1
                AND name = 'DEFAULT' AND block_size = 8192)
       WHERE name = 'DEFAULT' AND block_size = 8192),
 pga_times AS 
     (SELECT current_size / 1048576 current_pga_mb,
             pga_target_for_estimate / 1048576 target_pga_mb,
             estd_time-base_time pga_secs_delta 
        FROM v$pga_target_advice , 
             (SELECT pga_target_for_estimate current_size,
                     estd_time base_time
                FROM v$pga_target_advice 
               WHERE pga_target_factor = 1))
SELECT current_cache_mb||'MB->'||target_cache_mb||'MB' Buffer_cache,
       current_pga_mb||'->'||target_pga_mb||'MB' PGA,
       pga_secs_delta,cache_secs_delta,
       (pga_secs_delta+cache_secs_delta) total_secs_delta
  FROM db_cache_times d,pga_times p
 WHERE (target_pga_mb+target_cache_mb)
        <=(current_pga_mb+current_cache_mb)
   AND (pga_secs_delta+cache_secs_delta) <0
 ORDER BY (pga_secs_delta+cache_secs_delta);


