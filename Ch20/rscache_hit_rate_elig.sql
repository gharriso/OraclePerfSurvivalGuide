col created format 99,999 heading "Caches|Created"
col find_count1000 format 999,999,999 heading "Result Cache |Hit/1000"
col find_created_pct format 99,999,999 heading "Find/Created|PCT"
col execs1000 format 99,999,999 heading "Executions|/1000"
col find_exec_pct format 999.99 heading "Find/Exec|PCT"
col rs_eligible_execs1000 format 99,999,999 heading "RCache Execs|/1000"
col eligible_find_pct format 999.99 heading "RCache Exec|Hit PCT"

WITH execs AS 
    (SELECT SUM(DECODE(result_cache, 1, executions))
            rs_eligible_execs, SUM(executions) execs
       FROM v$sql
       LEFT OUTER JOIN
           (SELECT sql_id, child_number, 1 result_cache
              FROM v$sql_plan
             WHERE operation = 'RESULT CACHE')
             USING (sql_id, child_number)),
    rscache AS
    (SELECT SUM(DECODE(name, 'Create Count Success', VALUE)) created,
            SUM(DECODE(name, 'Find Count', VALUE)) find_count
       FROM v$result_cache_statistics)
SELECT created, find_count/1000 find_count1000, 
       ROUND(find_count * 100 / created,2) find_created_pct,
       execs/1000 execs1000, 
       ROUND(find_count * 100 / execs,2) find_exec_pct,
       rs_eligible_execs/1000 rs_eligible_execs1000,
       ROUND(find_count * 100 / rs_eligible_execs,2) eligible_find_pct
FROM   rscache CROSS JOIN execs;

