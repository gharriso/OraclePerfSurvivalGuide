rem *********************************************************** 
rem
rem	File: flush_time.sql 
rem	Description: redo log flush frequency and wait times 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 682
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on 
WITH sysstat AS (
    SELECT SUM(CASE WHEN name LIKE '%time' 
                    THEN VALUE END) total_time,
           SUM(CASE WHEN name LIKE '%flush time' 
                    THEN VALUE END) flush_time,
           SUM(CASE WHEN name LIKE '%served' 
                    THEN VALUE END) blocks_served 
    FROM gv$sysstat
    WHERE name IN
                  ('gc cr block build time',
                   'gc cr block flush time',
                   'gc cr block send time',
                   'gc current block pin time',
                   'gc current block flush time',
                   'gc current block send time',
                   'gc cr blocks served',
                   'gc current blocks served')),
     cr_block_server as (
    SELECT SUM(flushes) flushes, SUM(data_requests) data_requests
    FROM gv$cr_block_server     )
SELECT ROUND(flushes*100/blocks_served,2) pct_blocks_flushed,
       ROUND(flush_time*100/total_time,2) pct_lms_flush_time
  FROM sysstat CROSS JOIN cr_block_server; 
