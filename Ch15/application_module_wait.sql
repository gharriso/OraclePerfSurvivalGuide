rem *********************************************************** 
rem
rem	File: application_module_wait.sql 
rem	Description: Show SQLs for a particular module with lock waits 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 472
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


SELECT COUNT( * ), SUM(elapsed_time) elapsed_Time,
       SUM(application_wait_time) application_time,
       ROUND(SUM(elapsed_time) * 100 / 
            SUM(application_wait_time), 2)
            pct_application_time
FROM v$sql
WHERE module = 'OPSG'
 
