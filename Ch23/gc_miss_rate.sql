rem *********************************************************** 
rem
rem	File: gc_miss_rate.sql 
rem	Description: "Global cache ""miss rate"" by instance "
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 693
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col instance_name format a10 heading "Instance|name"
col logical_reads format  999,999,999 heading "Logical|Reads"
col gc_blocks_recieved format 999,999,999 heading "GC Blocks|Received"
col physical_reads format 999,999,999 heading "Physical|Reads"
col phys_to_logical_pct format 99.99 heading "Phys/Logical|Pct"
col gc_to_logical_pct format 99.99 heading "GC/Logical|Pct"
set pagesize 10000
set lines 80 
set echo on 
WITH sysstats AS (
    SELECT inst_id,
           SUM(CASE WHEN name LIKE 'gc%received' 
                    THEN VALUE END) gc_blocks_received,
           SUM(CASE WHEN name = 'session logical reads' 
                    THEN VALUE END) logical_reads,
           SUM(CASE WHEN name = 'physical reads' 
                    THEN VALUE END) physical_reads
    FROM gv$sysstat
    GROUP BY inst_id)
SELECT instance_name, logical_reads, gc_blocks_received, physical_reads,
       ROUND(physical_reads*100/logical_reads,2) phys_to_logical_pct,
       ROUND(gc_blocks_received*100/logical_reads,2) gc_to_logical_pct 
  FROM sysstats JOIN gv$instance
 USING (inst_id); 
