rem *********************************************************** 
rem
rem	File: sql_cache_stats.sql 
rem	Description: Result set cache statistics for SQL statements 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 600
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 75
col sql_id noprint format a13
col executions format 99,999,999 heading "Execs"
col cached_result_sets format 99,999 heading "Cached|Results" 
col cache_hits format 99,999,999 heading "Cache|Hits"
col avg_rows noprint format 99,999.99 heading "Query|Avg Rows"
col avg_gets_nocache format 9,999,999 heading "Avg Gets|w/o Cache"
col estd_saved_gets  format 9,999,999,999 heading "Estd. Saved|Buffer gets|/1000"
col buffer_gets format 99,999,999,999 heading "Buffer |Gets"
col sql_text format a70 heading "Sql Text"
set echo on 

WITH result_cache AS (SELECT cache_id, 
                             COUNT( * ) cached_result_sets,
                             SUM(scan_count) hits
                      FROM v$result_cache_objects
                      GROUP BY cache_id)
SELECT /*+ ordered */
      s.sql_id, s.executions, o.cached_result_sets, 
       o.hits cache_hits,
       ROUND(s.rows_processed / executions) avg_rows,
       buffer_gets,
       ROUND(buffer_gets / (executions - o.hits)) 
          avg_gets_nocache,
       round((buffer_gets / (executions - o.hits))
          *o.hits) estd_saved_gets, 
        s.sql_text
FROM       v$sql_plan p
        JOIN
           result_cache o
        ON (p.object_name = o.cache_id)
     JOIN
        v$sql s
     ON (s.sql_id = p.sql_id AND s.child_number = p.child_number)
WHERE operation = 'RESULT CACHE'
 order by 7 desc ; 
