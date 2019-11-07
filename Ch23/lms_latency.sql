rem *********************************************************** 
rem
rem	File: lms_latency.sql 
rem	Description: LMS latency breakdown 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 681
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col instance_name format a12 heading "Instance"
col current_blocks_served format 999,999,999 heading "Current Blks|Served"
col avg_current_ms format 99.99 heading "Avg|CU ms"
col cr_blocks_served format 999,999,999 heading "CR Blks|Served"
col avg_cr_ms format 99.99 heading "Avg|Cr ms"
set pages 1000
set lines 80
set echo on 


WITH sysstats AS (
    SELECT instance_name,
           SUM(CASE WHEN name LIKE 'gc cr%time' 
                    THEN VALUE END) cr_time,
           SUM(CASE WHEN name LIKE 'gc current%time' 
                    THEN VALUE END) current_time,
           SUM(CASE WHEN name LIKE 'gc current blocks served' 
                    THEN VALUE END) current_blocks_served,
           SUM(CASE WHEN name LIKE 'gc cr blocks served' 
                    THEN VALUE END) cr_blocks_served
      FROM gv$sysstat JOIN gv$instance
      USING (inst_id)
    WHERE name IN
                  ('gc cr block build time',
                   'gc cr block flush time',
                   'gc cr block send time',
                   'gc current block pin time',
                   'gc current block flush time',
                   'gc current block send time',
                   'gc cr blocks served',
                   'gc current blocks served')
    GROUP BY instance_name)
SELECT instance_name , current_blocks_served, 
       ROUND(current_time*10/current_blocks_served,2) avg_current_ms,
       cr_blocks_served, 
       ROUND(cr_time*10/cr_blocks_served,2) avg_cr_ms 
  FROM sysstats; 
