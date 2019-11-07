rem *********************************************************** 
rem
rem	File: kmgsbsmemadv.sql 
rem	Description: Query against X$KMSGSBSMEMADV (basis of V$MEMORY_TARGET_ADVICE) 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 593
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col memory_size format 99,999 heading "Memory|Size"
col memory_size_pct format 9999.99 heading "Memory|Pct"
col sga_size format 9,999 heading "SGA|Size"
col pga_size format 9,999 heading "PGA|Size"
col estd_db_time format 999,999,999 heading "Est. DB|Time"
col estd_sga_time format 999,999,999 heading "Est. SGA|Time"
col estd_pga_time format 999,999,999 heading "Est. PGA|Time"
col estd_time format 999,999,999
col pat_mb  format 99,999 heading "PGA Target|MB"

SET pages 10000
SET lines 100
SET echo ON 

SELECT memsz memory_size, ROUND(memsz * 100 / base_memsz) memory_size_pct,
       sga_sz sga_size, pga_sz pga_size, dbtime estd_db_time,
       ROUND(dbtime * 100 / base_estd_dbtime) db_time_pct,
       sgatime estd_sga_time, pgatime estd_pga_time
FROM x$kmgsbsmemadv
ORDER BY memsz;

SELECT sga_size, estd_db_time
FROM v$sga_target_advice
WHERE sga_size_factor = 1
ORDER BY sga_size_factor;

SELECT pga_target_for_estimate / 1048576 pat_mb, estd_time
FROM v$pga_target_advice
WHERE pga_target_factor = 1;
/* Formatted on 13/03/2009 9:46:03 PM (QP5 v5.120.811.25008) */
