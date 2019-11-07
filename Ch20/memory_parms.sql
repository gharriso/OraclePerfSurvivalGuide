rem *********************************************************** 
rem
rem	File: memory_parms.sql 
rem	Description: Report on memory related parameters 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 594
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pagesize 1000
set lines 100
column name format a22
column description format a40
column display_value format a6 heading "Value"
set echo on

SELECT name, display_value, description
FROM v$parameter
WHERE name IN
            ('sga_target',
             'memory_target',
             'memory_max_target',
             'pga_aggregate_target',
             'shared_pool_size',
             'large_pool_size',
             'java_pool_size')
      OR name LIKE 'db%cache_size'
ORDER BY name
/
