rem *********************************************************** 
rem
rem	File: diskgroup_performance.sql 
rem	Description: ASM diskgroup IO throughput and service time 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 22 Page 645
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col name format a12 heading "Diskgroup|Name"
col type format a6 heading "Redundacy|Type"
col total_gb format 9,999 heading "Size|GB"
col active_disks format 99 heading "Active|Disks"
col reads1k format 9,999,999 heading "Reads|/1000"
col writes1k format 9,999,999 heading "Writes|/1000"
col read_time format 999,999 heading "Read Time|Secs"
col write_time format 999,999 heading "Write Time|Secs"
col avg_read_ms format 999.99 heading "Avg Read|ms"
set pagesize 1000
set lines 80
set echo on

SELECT name, ROUND(total_mb / 1024) total_gb, active_disks,
       reads / 1000 reads1k, writes / 1000 writes1k,
       ROUND(read_time) read_time, ROUND(write_time) write_time,
       ROUND(read_time * 1000 / reads, 2) avg_read_ms
FROM     v$asm_diskgroup_stat dg
     JOIN
         (SELECT group_number, COUNT(DISTINCT disk_number) active_disks,
                 SUM(reads) reads, SUM(writes) writes,
                 SUM(read_time) read_time, SUM(write_time) write_time
          FROM gv$asm_disk_stat
          WHERE mount_status = 'CACHED'
          GROUP BY group_number) ds
     ON (ds.group_number = dg.group_number)
ORDER BY dg.group_number;
