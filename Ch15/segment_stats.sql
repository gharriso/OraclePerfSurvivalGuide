rem *********************************************************** 
rem
rem	File: segment_stats.sql 
rem	Description: Show segments with the highest lock waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 471
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column object_name format a30
column row_lock_wait format 9,999,999
column pct format 99.99
set echo on 

SELECT object_name, VALUE row_lock_waits, 
       ROUND(VALUE * 100 / SUM(VALUE) OVER (), 2) pct
  FROM v$segment_statistics
 WHERE statistic_name = 'row lock waits' AND VALUE > 0
 ORDER BY VALUE DESC; 
 
