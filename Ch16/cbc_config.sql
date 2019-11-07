rem *********************************************************** 
rem
rem	File: cbc_config.sql 
rem	Description: "Number of Cache Buffers Chains latches & number of buffers covered
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 503
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column cbc_latches heading "CBC Latch|Count"
column buffers heading "Buffer Cache|Buffers"
column min_buffer_per_latch heading "Min Buffer|Per Latch"
column max_buffer_per_latch heading "Max Buffer|Per Latch"
column avg_buffer_per_latch heading "Avg Buffer|Per Latch"
set echo on 

SELECT COUNT(DISTINCT l.addr) cbc_latches,  
       SUM(COUNT( * )) buffers,
       MIN(COUNT( * )) min_buffer_per_latch,
       MAX(COUNT( * )) max_buffer_per_latch,
       ROUND(AVG(COUNT( * ))) avg_buffer_per_latch
FROM    v$latch_children l
     JOIN
        x$bh b
     ON (l.addr = b.hladdr)
WHERE name = 'cache buffers chains'
GROUP BY l.addr; 
 

 
