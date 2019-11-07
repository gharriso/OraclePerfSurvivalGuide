rem *********************************************************** 
rem
rem	File: gc_blocks_lost.sql 
rem	Description: Lost blocks report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 677
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col value format 999,999,999,999
col name format a30
set echo on

SELECT name, SUM(VALUE) value
FROM gv$sysstat
WHERE    name LIKE 'gc%lost'
      OR name LIKE 'gc%received'
      OR name LIKE 'gc%served'
GROUP BY name
ORDER BY name;
