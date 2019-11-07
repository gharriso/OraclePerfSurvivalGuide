set echo on 
set lines 100
set pages 1000

column buffer_gets format 999,999,999,999
column disk_reads format 999,999,999,999
column miss_rate format 99.99
column pct_io_time format 99.99 

SELECT  buffer_gets,disk_reads,
       ROUND(  disk_reads  * 100 /   buffer_gets , 2) miss_rate,
       ROUND(  user_io_wait_time  * 100 /   elapsed_time , 2) pct_io_time,
       ROUND(  elapsed_time  /   executions  / 1000, 2) avg_ms,
        sql_text 
FROM v$sql
WHERE   sql_text NOT LIKE '%V$SQL%'
      AND buffer_gets > 0
      AND executions > 0
      and sql_text like '%FROM TXN_%' 
ORDER BY  (buffer_gets) DESC
/
