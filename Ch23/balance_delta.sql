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
            SUM(CASE WHEN stat_name IN ('CPU') 
                THEN  VALUE  END) cpu_time
      FROM table(opsg_pkg.rac_wait_time_report()) 
     GROUP BY inst_id                 )
SELECT instance_name, 
       ROUND(db_time/1000000,2) db_time_secs, 
       ROUND(db_time*100/SUM(db_time) over(),2) db_time_pct,
       ROUND(cpu_time/1000000,2) cpu_time_secs, 
       ROUND(cpu_time*100/SUM(cpu_time) over(),2)  cpu_time_pct
  FROM  sys_time
  JOIN gv$instance USING (inst_id); 
