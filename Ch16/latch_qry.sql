rem *********************************************************** 
rem
rem	File: latch_qry.sql 
rem	Description: "Latch statistics - gets
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 496
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column name format a30 
column pct_of_gets format 99.00 heading "Pct of|Gets"
column pct_of_misses format 99.00 heading "Pct of|Misses"
column pct_of_sleeps format 99.00 heading "Pct of|Sleeps"
column pct_of_wait_time format 99.00 heading "Pct of|Wait Time"

set echo on 

WITH latch AS (
    SELECT name,
           ROUND(gets * 100 / SUM(gets) OVER (), 2) pct_of_gets,
           ROUND(misses * 100 / SUM(misses) OVER (), 2) pct_of_misses,
           ROUND(sleeps * 100 / SUM(sleeps) OVER (), 2) pct_of_sleeps,
           ROUND(wait_time * 100 / SUM(wait_time) OVER (), 2)
                 pct_of_wait_time
      FROM v$latch)
SELECT *
FROM latch
WHERE pct_of_wait_time > .1 OR pct_of_sleeps > .1
ORDER BY pct_of_wait_time DESC; 
