rem *********************************************************** 
rem
rem	File: lock_type.sql 
rem	Description: Show definition of all lock codes 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 460
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 



column type format a4
column name format a25
column description format a50
set echo on 

SELECT TYPE, name, description
  FROM v$lock_type
 ORDER BY TYPE; 
