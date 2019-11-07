rem *********************************************************** 
rem
rem	File: cbc_blocks.sql 
rem	Description: Blocks with the highest touch counts and latches involved 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 504
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column owner format a12
column object_name format a20
column object_type format a10
column occurences format 999,999
column touches format 999,999,999

set pagesize 1000
set lines 100

WITH cbc_latches AS 
    (SELECT addr, name, sleeps,
            rank() over(order by sleeps desc) ranking 
       FROM v$latch_children
      WHERE name = 'cache buffers chains')
SELECT owner, object_name,object_type,
       COUNT(distinct l.addr) latches,
       SUM(tch) touches,count(*) blocks
  FROM cbc_latches l JOIN x$bh b
       ON (l.addr = b.hladdr)
  JOIN dba_objects o
       ON (b.obj = o.object_id)
 WHERE l.ranking <=100 
 GROUP BY owner, object_name,object_type
ORDER BY sum(tch) DESC;  
 
