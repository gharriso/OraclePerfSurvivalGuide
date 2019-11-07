rem *********************************************************** 
rem
rem	File: result_cache_statistics.sql 
rem	Description: Result set cache statistics 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 599
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col name format a30
col value format 999,999,999,999
set pages 1000
set lines 100
set echo on 
SELECT name,value FROM v$result_cache_statistics;
