rem *********************************************************** 
rem
rem	File: queryProfiler.sql 
rem	Description: Report on data held in the PLSQL_PROFILER tables 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 12 Page 357
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set lines 100
set pages 10000

col line# format 9999 Heading "Line"
col unit_name format a11 heading "Unit Name"
col time_ms format 999999 heading "Time|(ms)"
col pct_time format 99.99 heading "Pct of|Time"
col execs format 999999 heading "Execs"
col text format a40 heading "Line text"
 
set echo on 

WITH plsql_qry AS (
  SELECT u.unit_name, line#,
         ROUND (d.total_time / 1e9) time_ms, 
         round(d.total_time * 100 / sum(d.total_time) over(),2) pct_time, 
         d.total_occur as execs, 
         substr(ltrim(s.text),1,40) as text,
         dense_rank() over(order by d.total_time desc) ranking 
    FROM plsql_profiler_runs r JOIN plsql_profiler_units u USING (runid)
         JOIN plsql_profiler_data d USING (runid, unit_number)
         LEFT OUTER JOIN all_source s
         ON (    s.owner = u.unit_owner
             AND s.TYPE = u.unit_type
             AND s.NAME = u.unit_name
             AND s.line = d.line# )
   WHERE r.run_comment = 'Profiler Demo 2'
    )
select unit_name,line#,time_ms,pct_time,execs,text 
  from plsql_qry 
 where ranking <=5      
ORDER BY ranking;
 
