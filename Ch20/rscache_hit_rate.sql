rem *********************************************************** 
rem
rem	File: rscache_hit_rate.sql 
rem	Description: Result set cache efficiency 
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


col resultsets format 9,999 heading "Current|sets"
col statements format 9,999 heading "Unique|SQL"
col created format 99,999 heading "Sets|Created"
col find_count1000 format 999,999,999 heading "Sets Found|/1000"
col find_created_pct format 999,999.99 heading "Find/Created|PCT"
col execs1000 format 99,999,999 heading "Executions|/1000"
col find_exec_pct format 999.99 heading "Find/Exec|PCT"


WITH execs AS (SELECT VALUE executions
               FROM v$sysstat
               WHERE name = 'execute count'),
    rscache AS
       (SELECT SUM(DECODE(name, 'Create Count Success',
                    VALUE)) created,
               SUM(DECODE(name, 'Find Count', VALUE)) find_count
        FROM v$result_cache_statistics),
    rscounts AS (SELECT COUNT( * ) resultSets,
                        COUNT(DISTINCT cache_id) statements
                 FROM v$result_cache_objects
                 WHERE TYPE = 'Result')
SELECT resultSets, statements, created, 
       find_count / 1000 find_count1000,
       ROUND(find_count * 100 / created, 2) find_created_pct,
       executions / 1000 execs1000,
       ROUND(find_count * 100 / executions, 2) find_exec_pct
FROM   rscache CROSS JOIN  execs
       CROSS JOIN  rscounts;

