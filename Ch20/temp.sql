SELECT size_for_estimate, (estd_physical_read_time - current_time)*1000 estd_phys_io_micro
FROM v$db_cache_advice,
     (SELECT size_for_estimate current_size,
             estd_physical_read_time current_time 
      FROM v$db_cache_advice
      WHERE size_factor = 1 AND name = 'DEFAULT' AND block_size = 8192)
WHERE name = 'DEFAULT' AND block_size = 8192;


select estd_physical_read_time/estd_physical_reads,a.* from V$db_cache_advice a ; 

select average_wait/10 average_wait_ms from v$system_event where event='db file sequential read'; 
