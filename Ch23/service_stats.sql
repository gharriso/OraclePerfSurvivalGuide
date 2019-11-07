rem *********************************************************** 
rem
rem	File: service_stats.sql 
rem	Description: Report on service workload by instance 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 689
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col instance_name format a8 heading "Instance|Name"
col service_name format a15 heading "Service|Name"
col cpu_time format 99,999,999 heading "Cpu|secs"
col pct_instance format 999.99 heading "Pct Of|Instance"
col pct_service format 999.99 heading "Pct of|Service"
set lines 80
set pages 1000
set echo on 

BREAK ON instance_name skip 1
COMPUTE SUM OF cpu_time ON instance_name

WITH service_cpu AS (SELECT instance_name, service_name,
                            round(SUM(VALUE)/1000000,2) cpu_time
                     FROM     gv$service_stats
                          JOIN
                              gv$instance
                          USING (inst_id)
                     WHERE stat_name IN ('DB CPU', 'background cpu time')
                     GROUP BY  instance_name, service_name )
SELECT instance_name, service_name, cpu_time,
       ROUND(cpu_time * 100 / SUM(cpu_time) 
             OVER (PARTITION BY instance_name), 2) pct_instance,
       ROUND(  cpu_time
             * 100
             / SUM(cpu_time) OVER (PARTITION BY service_name), 2)
           pct_service
FROM service_cpu
WHERE cpu_time > 0
ORDER BY instance_name, service_name; 
