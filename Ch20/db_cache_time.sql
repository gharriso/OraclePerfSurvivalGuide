col current_size format 99,999 heading "Current|MB" 
col size_for_estimate format 99,999 heading "Estimate|MB"
col estd_io_seconds_delta format 9,999,999,999 heading "Est IO |Time Delta (s)"
col physical_reads_delta format 99,999,999,999 heading "Phys Reads|Delta"
set pages 1000
set lines 80
set echo on 

SELECT current_size, size_for_estimate,
       (estd_physical_read_time - current_time) 
         estd_io_seconds_delta,
       estd_physical_reads - current_reads 
         physical_reads_delta
FROM v$db_cache_advice,
     (SELECT size_for_estimate current_size,
             estd_physical_read_time current_time,
             estd_physical_reads current_reads
      FROM v$db_cache_advice
      WHERE size_factor = 1 AND name = 'DEFAULT'
        AND block_size = 8192)
WHERE name = 'DEFAULT' AND block_size = 8192;
 

