set pagesize 1000
set lines 100
column block_size_kb format 99 heading "Block|Size K"
column current_size heading "Current|MB"
column target_size heading "Target|MB"
column prev_size heading "Prev|MB"

set echo on

SELECT name, block_size / 1024 block_size_kb, current_size,
        target_size,prev_size
FROM v$buffer_pool;
 
