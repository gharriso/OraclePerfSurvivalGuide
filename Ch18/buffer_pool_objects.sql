rem *********************************************************** 
rem
rem	File: buffer_pool_objects.sql 
rem	Description: Segments cached in the buffer pools 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 540
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on
set pages 10000
set lines 100
column segment format a20 heading "Segment"
column buffer_pool format a10 heading "Buffer|Pool"
column cached_blocks format 99,999 heading "Cached|Blocks"
column pct_cached format 99,999.99 heading "Pct|Cached"
column dirty_blocks format 99,999 heading "Dirty|blocks"
column seg_blocks format 9,999,999 heading "Segment|blocks"


SELECT s.buffer_pool, o.owner || '.' || o.object_name segment,
       COUNT( * ) cached_blocks, s.blocks seg_blocks,
       ROUND(COUNT( * ) * 100 / s.blocks, 2) pct_cached,
       SUM(DECODE(dirty, 'Y', 1, 0)) dirty_blocks
  FROM v$bh  
  JOIN dba_objects o  ON (object_id = objd)
  JOIN dba_segments s
    ON (o.owner = s.owner AND object_name = segment_name)
GROUP BY s.buffer_pool, s.blocks, o.owner, o.object_name
HAVING COUNT( * ) > 100
ORDER BY COUNT( * ) DESC;
 
