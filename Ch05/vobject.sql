rem *********************************************************** 
rem
rem	File: vobject.sql 
rem	Description: Show usage statistics for indexes 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 5 Page 122
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


/* Formatted on 2008/08/31 16:58 (Formatter Plus v4.8.7) */
SET lines 100
SET pages 10000
COLUMN index_name format a20
COLUMN table_name format a20
COLUMN used format a4

SET echo on

SELECT index_name, table_name, used, start_monitoring
  FROM v$object_usage
 WHERE MONITORING = 'YES';

