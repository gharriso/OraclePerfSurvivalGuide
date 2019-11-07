col total_write_mb format 999,999,999
col total_write_reqs format 999,999,999,999
col avg_write_kb format 99,999.99
set pagesize 1000
set lines 70
set echo on 

SELECT (small_write_megabytes + large_write_megabytes) total_write_mb,
       (small_write_reqs + large_write_reqs) total_write_reqs,
       ROUND(  (small_write_megabytes + large_write_megabytes)
             * 1024
             / (small_write_reqs + large_write_reqs), 2)
          avg_write_kb 
FROM v$iostat_file f
WHERE filetype_name = 'Flashback Log'; 
