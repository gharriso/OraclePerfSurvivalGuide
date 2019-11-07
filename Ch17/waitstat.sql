rem *********************************************************** 
rem
rem	File: waitstat.sql 
rem	Description: Buffer busy waits by buffer type 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 17 Page 526
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on
column class format a30
column count format 9,999,999
column pct format 999.99

SELECT class, COUNT, time, 
       ROUND(time * 100 / SUM(time) OVER (), 2) pct
FROM v$waitstat
ORDER BY time DESC
/

/* Formatted on 14-Feb-2009 15:18:31 (QP5 v5.120.811.25008) */
