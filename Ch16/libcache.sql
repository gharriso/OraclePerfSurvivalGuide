rem *********************************************************** 
rem
rem	File: libcache.sql 
rem	Description: Library cache statistics 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 499
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column namespace format a16
column gets format 999,999,999
column gethits format 999,999,999
column hitraio format 99.00
column pct_gets format 99.00
column pct_misses format 99.00 

set echo on 

SELECT namespace, gets, gethits,
       ROUND(CASE gets WHEN 0 THEN NULL 
             ELSE gethits * 100 / gets END, 2) hitratio, 
       ROUND(gets * 100 / SUM(gets) OVER (), 2) pct_gets,
       ROUND((gets - gethits) * 100 / SUM(gets - gethits) OVER (), 2)
          pct_misses
FROM v$librarycache; 
