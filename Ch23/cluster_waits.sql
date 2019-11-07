rem *********************************************************** 
rem
rem	File: cluster_waits.sql 
rem	Description: Break out of cluster waits compared to other categories 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 670
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column wait_type format a35 heading "Wait Type"
column lock_name format a12
column waits_1000 format  99,999,999 heading "Waits|\1000"
column time_waited_hours format 99,999.99 heading "Time|Hours"
column pct_time format 99.99 Heading "Pct of|Time"
column avg_wait_ms format 9,999.99 heading "Avg Wait|Ms"
set pagesize 10000
set lines 100
set echo on

WITH system_event AS 
   (SELECT CASE
             WHEN wait_class = 'Cluster' THEN event
             ELSE wait_class
           END  wait_type, e.*
     FROM gv$system_event e)
SELECT wait_type,  ROUND(total_waits/1000,2) waits_1000 ,
       ROUND(time_waited_micro/1000000/3600,2) time_waited_hours,
       ROUND(time_waited_micro/1000/total_waits,2) avg_wait_ms  ,
       ROUND(time_waited_micro*100
          /SUM(time_waited_micro) OVER(),2) pct_time  
FROM (SELECT wait_type, SUM(total_waits) total_waits,
             SUM(time_waited_micro) time_waited_micro
        FROM system_event e
       GROUP BY wait_type 
       UNION
      SELECT 'CPU',   NULL, SUM(VALUE)
        FROM gv$sys_time_model
       WHERE stat_name IN ('background cpu time', 'DB CPU'))  
WHERE wait_type <> 'Idle'
ORDER BY  time_waited_micro  DESC;
 
