rem *********************************************************** 
rem
rem	File: balance.sql 
rem	Description: Cluster balance report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 684
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col instance_name format a8 heading "Instance|Name"
col db_time_pct       format 99.99 heading "Pct of|DB Time"
col cpu_time_pct      format 99.99 heading "Pct of|CPU Time"
col db_time_secs      format 9,999,999.99 heading "DB Time|(secs)"
col cpu_time_secs     format 9,999,999.99 heading "CPU Time|(secs)"

set lines 80
set pages 1000
set echo on 


WITH sys_time AS (
    SELECT inst_id, SUM(CASE stat_name WHEN 'DB time' 
                        THEN VALUE END) db_time,
            SUM(CASE WHEN stat_name IN ('DB CPU', 'background cpu time') 
                THEN  VALUE  END) cpu_time
      FROM gv$sys_time_model
     GROUP BY inst_id                 )
SELECT instance_name, 
       ROUND(db_time/1000000,2) db_time_secs, 
       ROUND(db_time*100/SUM(db_time) over(),2) db_time_pct,
       ROUND(cpu_time/1000000,2) cpu_time_secs, 
       ROUND(cpu_time*100/SUM(cpu_time) over(),2)  cpu_time_pct
  FROM  sys_time
  JOIN gv$instance USING (inst_id); 
