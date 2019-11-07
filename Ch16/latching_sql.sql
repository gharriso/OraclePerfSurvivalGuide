rem *********************************************************** 
rem
rem	File: latching_sql.sql 
rem	Description: SQLs with the highest concurrency waits (possible latch/mutex-related) 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 497
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column sql_text format a40 heading "SQL Text"
column con_time_ms format 99,999,999 heading "Conc Time(ms)"
column con_time_pct format 999.99 heading "SQL Conc|Time%"
column pct_of_con_time format 999.99 heading "% Tot|ConcTime"
set pagesize 1000
set lines 100
set echo on 

WITH sql_conc_waits AS 
    (SELECT sql_id, SUBSTR(sql_text, 1, 80) sql_text, 
            concurrency_wait_time/1000 con_time_ms,
            elapsed_time,
            ROUND(concurrency_wait_Time * 100 / 
                elapsed_time, 2) con_time_pct,
            ROUND(concurrency_wait_Time* 100 / 
                SUM(concurrency_wait_Time) OVER (), 2) pct_of_con_time,
            RANK() OVER (ORDER BY concurrency_wait_Time DESC) ranking
       FROM v$sql
      WHERE elapsed_time > 0)
SELECT sql_text, con_time_ms, con_time_pct,
       pct_of_con_time
FROM sql_conc_waits
WHERE ranking <= 10
ORDER BY ranking  ; 
 
