rem *********************************************************** 
rem
rem	File: db_cache_hist.sql 
rem	Description: DB cache advise shown as a histogram 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 548
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 120
set echo on
column size_mb format 99,999 heading "Size|MB"
column estd_physical_reads format 999,999,999 heading "Est Phys|Reads"
column estd_factor_pct format 9,999.99 heading "Relative|Phy Rds"
column histogram format a60

SELECT size_for_estimate size_mb,
       ROUND(estd_physical_read_factor * 100, 2) estd_factor_pct,
       RPAD(' ',
       ROUND(estd_physical_reads / MAX(estd_physical_reads) OVER () * 60),
       DECODE(size_factor, 1, '-', '*'))
          histogram
FROM v$db_cache_advice
WHERE name = 'DEFAULT' and block_size='8192' 
ORDER BY 1 DESC
/

 
