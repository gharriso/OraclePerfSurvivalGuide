WITH db_cache_times AS 
    (SELECT current_size current_cache_mb, 
            size_for_estimate target_cache_mb,
            (estd_physical_read_time - current_time) cache_seconds_delta
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
             ROUND((estd_extra_bytes_rw - current_extra_bytes_rw) * 0.1279 / 
                1000000,2)   pga_seconds_delta 
        FROM v$pga_target_advice, 
             (SELECT pga_target_for_estimate current_size,
                     estd_extra_bytes_rw AS current_extra_bytes_rw
                FROM v$pga_target_advice WHERE pga_target_factor = 1))
SELECT current_cache_mb,target_cache_mb,
       current_pga_mb,target_pga_mb,
       pga_seconds_delta,cache_seconds_delta,
       (pga_seconds_delta+cache_seconds_delta) total_seconds_delta
  FROM db_cache_times d,pga_times p
 WHERE (target_pga_mb+target_cache_mb)<=(current_pga_mb+current_cache_mb)
   AND (pga_seconds_delta+cache_seconds_delta) <0
 ORDER BY (pga_seconds_delta+cache_seconds_delta)
 

/

/* Formatted on 8-Mar-2009 11:52:25 (QP5 v5.120.811.25008) */
