rem *********************************************************** 
rem
rem	File: filemetric.sql 
rem	Description: Short term IO statistics from v$filemetric 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 622
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col tablespace_name format a15
col sample_time format 999.99 heading "Smpl|Secs" noprint
col avg_read_time_ms format 999.99 heading "Avg Rd|(ms)"
col avg_write_Time_ms format 999.99 heading "Avg Wrt|(ms)"
col physical_reads format 9,999,999 heading "Phys|Reads"
col physical_writes format 9,999,999 heading "Phys|Writes"
col pct_io format 999.99 heading "Pct|IO"
col blks_per_read format 999.99 heading "Blks|\Rd"
set pagesize 1000
set lines 75
set echo on

SELECT tablespace_name, intsize_csec / 100 sample_time,
       ROUND(AVG(average_read_time) * 10, 2) avg_read_time_ms,
       ROUND(AVG(average_write_time) * 10, 2) avg_write_time_ms,
       SUM(physical_reads) physical_reads, 
       SUM(physical_writes) physical_writes,
       ROUND((SUM(physical_reads) + SUM(physical_writes)) * 100 / 
         SUM(SUM(physical_reads) + SUM(physical_writes)) 
          OVER (), 2) pct_io,
       CASE
          WHEN SUM(physical_reads) > 0 THEN
             ROUND(SUM(physical_block_reads) / SUM(physical_reads), 2)
       END  blks_per_read
  FROM v$filemetric JOIN dba_data_files
       USING (file_id)
GROUP BY tablespace_name, file_id, end_time, intsize_csec
ORDER BY 7 DESC;
 
