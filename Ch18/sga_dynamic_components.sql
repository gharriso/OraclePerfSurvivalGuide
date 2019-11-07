rem *********************************************************** 
rem
rem	File: sga_dynamic_components.sql 
rem	Description: Query on V$SGA_DYNAMIC_COMPONENTS 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 552
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 100
set echo on 
 
SELECT component, ROUND(current_size / 1048576) current_mb,
       ROUND(min_size / 1048576) minimum_mb,
       ROUND(user_specified_size / 1048576) specified_mb
FROM v$sga_dynamic_components sdc;
