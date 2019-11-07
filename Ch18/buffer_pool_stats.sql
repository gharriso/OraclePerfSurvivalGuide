rem *********************************************************** 
rem
rem	File: buffer_pool_stats.sql 
rem	Description: Buffer pool IO statistics 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 546
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pagesize 1000
set lines 100
column name format a7
column block_size_kb format 99 heading "Block|Size K"
column free_buffer_wait format 99,999 heading "Free Buff|Wait"
column buffer_busy_wait format 99,999 heading "Buff Busy|Wait"
column db_change format 999,999,999 heading "DB Block|Chg /1000"
column db_gets format 99,999,999 heading "DB Block|Gets /1000"
column con_gets format 99,999,999 heading "Consistent|gets /1000"
column phys_rds format 99,999,999 heading "Physical|Reads /1000"
column current_size format 9,999 heading "Current|MB"
column prev_size format 9,999 heading "Prev|MB"

set echo on

SELECT b.name, b.block_size / 1024 block_size_kb, 
       current_size, prev_size,
       ROUND(db_block_gets / 1000) db_gets,
       ROUND(consistent_gets / 1000) con_gets,
       ROUND(physical_reads / 1000) phys_rds
  FROM v$buffer_pool_statistics s
  JOIN v$buffer_pool b
   ON (b.name = s.name AND b.block_size = s.block_size);

