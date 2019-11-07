rem *********************************************************** 
rem
rem	File: plsqltime_sys.sql 
rem	Description: Query to reveal the overhead of PLSQL within the database 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 12 Page 355
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col db_time_secs format 999,999,999.99
col plsql_time_secs format 999,999,999.99
col pct_plsql_time format 99.99
col execs heading "Execs"
col text heading "Line text"
set lines 100
set pages 10000

set echo on

WITH plsql_times
       AS (SELECT SUM (CASE stat_name 
                            WHEN 'DB time' 
                            THEN value/1000000 END) AS db_time,
                  SUM(CASE stat_name
                           WHEN 'PL/SQL execution elapsed time'
                           THEN value / 1000000 END) AS plsql_time
             FROM v$sys_time_model
            WHERE stat_name IN ('DB time', 
                             'PL/SQL execution elapsed time'))
SELECT ROUND (db_time, 2) db_time_secs,
       ROUND (plsql_time, 2) plsql_time_secs,
       ROUND (plsql_time * 100 / db_time, 2) pct_plsql_time
  FROM plsql_times
/

/* Formatted on 3-Dec-2008 7:39:07 (QP5 v5.120.811.25008) */
