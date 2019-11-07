rem *********************************************************** 
rem
rem	File: rowcache_latches.sql 
rem	Description: Rowcache latch statistics 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 505
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 100
column namespace format a20
column pct_wait_time heading "Pct of|Wait"
column child# heading "Latch|Child#"
column gets heading "Gets"
column misses heading "Misses"
column sleeps heading "Sleeps"
column wait_time heading "Wait|Time"
set echo on

SELECT kqrsttxt namespace,  child#, misses, sleeps,wait_time, 
       ROUND(wait_time*100/sum(wait_time) over(),2) pct_wait_Time
  FROM v$latch_children
  JOIN (SELECT DISTINCT kqrsttxt, kqrstcln FROM x$kqrst) kqrst
       ON (kqrstcln = child#)
 WHERE name = 'row cache objects'  AND wait_Time > 0
 ORDER BY  wait_time DESC; 
