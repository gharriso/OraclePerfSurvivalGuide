rem *********************************************************** 
rem
rem	File: log_history.sql 
rem	Description: Log switch rates from v$log_history 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 637
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col min_minutes format 999.99 
col max_minutes format 999.99 
col avg_minutes format 999.99 
set pagesize 1000
set lines 70
set echo on 

WITH log_history AS
       (SELECT thread#, first_time,
               LAG(first_time) OVER (ORDER BY thread#, sequence#)
                  last_first_time,
               (first_time
                - LAG(first_time) OVER (ORDER BY thread#, sequence#))
                    * 24* 60   last_log_time_minutes,
               LAG(thread#) OVER (ORDER BY thread#, sequence#)
                   last_thread#
        FROM v$log_history)
SELECT ROUND(MIN(last_log_time_minutes), 2) min_minutes,
       ROUND(MAX(last_log_time_minutes), 2) max_minutes,
       ROUND(AVG(last_log_time_minutes), 2) avg_minutes
FROM log_history
WHERE     last_first_time IS NOT NULL
      AND last_thread# = thread#
      AND first_time > SYSDATE - 1; 
