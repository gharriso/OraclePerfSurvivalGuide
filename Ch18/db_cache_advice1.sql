rem *********************************************************** 
rem
rem	File: db_cache_advice1.sql 
rem	Description: Query on V$DB_CACHE_ADVICE
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 547
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col size_for_estimate format 99,999 heading "Cache|Size"
col size_factor_pct format 999.99 heading "Relative|Size|pct"
col estd_physical_read_factor_pct format 999.999 heading "Relative|Phys Rds|Pct"
col estd_physical_reads format 999,999,999 heading "Estimated|Phys Rds"
col estd_physical_read_time format 999,999,999 heading "Estimated|Read Time"
col estd_pct_of_db_time_for_reads format 999.99 heading "Estimated|Phys Reads|Pct of DB Time"
set pages 1000
set lines 100
set echo on

SELECT size_for_estimate, size_factor * 100 size_factor_pct,
       estd_physical_read_factor * 100 estd_physical_read_factor_pct,
       estd_physical_reads, estd_physical_read_time,
       estd_pct_of_db_time_for_reads
FROM v$db_cache_advice
WHERE name = 'DEFAULT' and block_size=8192
ORDER BY size_for_estimate;
/* Formatted on 22/02/2009 7:29:07 PM (QP5 v5.120.811.25008) */
