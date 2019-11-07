rem *********************************************************** 
rem
rem	File: top_gc_segments.sql 
rem	Description: Segments with the highest Global Cache activity 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 694
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col segment_name format a40
col gc_blocks_received format 999,999,999 
col pct format 99.99 
set pages 1000
set lines 80
set echo on 

WITH segment_misses AS
        (SELECT owner || '.' || object_name segment_name,
                SUM(VALUE) gc_blocks_received,
                ROUND(  SUM(VALUE)* 100
                      / SUM(SUM(VALUE)) OVER (), 2) pct
         FROM gv$segment_statistics
         WHERE statistic_name LIKE 'gc%received' AND VALUE > 0
         GROUP BY owner || '.' || object_name)
SELECT segment_name,gc_blocks_received,pct
  FROM segment_misses
 WHERE pct > 1
 ORDER BY pct DESC; 
