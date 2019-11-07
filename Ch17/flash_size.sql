rem *********************************************************** 
rem
rem	File: flash_size.sql 
rem	Description: Size of the flashback log buffer 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 17 Page 521
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on 

SELECT pool,name,round(bytes/1048576,2) mb
FROM v$sgastat
WHERE name LIKE 'flashback generation buff'; 

