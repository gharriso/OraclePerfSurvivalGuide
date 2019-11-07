rem *********************************************************** 
rem
rem	File: cachedPlsql.sql 
rem	Description: Show statements in the cache with PLSQL component and show pct of time spent in PLSQL
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 12 Page 356
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set lines 100
set pages 1000

col sql_text format a30 heading "SQL Text"
col elapsed_ms format 9999999 heading "Total|time ms"
col plsql_ms format 99999999 heading "PLSQL|time ms"
col pct_plsql format 99.99 heading "Pct|PLSQL"
col pct_total_plsql format 99.99 heading "PCT of|Tot PLSQL"
set echo on 

SELECT sql_id,
       SUBSTR (sql_text, 1, 150) AS sql_text,
       ROUND (elapsed_time / 1000) AS elapsed_ms,
       ROUND (plsql_exec_time / 1000) plsql_ms,
       ROUND (plsql_exec_time * 100 / elapsed_time, 2) pct_plsql,
       ROUND (plsql_exec_time * 100 / SUM (plsql_exec_time) OVER (), 2)
          pct_total_plsql
  FROM v$sql
 WHERE plsql_exec_time > 0 AND elapsed_time > 0
ORDER BY plsql_exec_time DESC
/
