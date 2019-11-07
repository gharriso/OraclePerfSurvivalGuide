rem *********************************************************** 
rem
rem	File: pga_target_advice.sql 
rem	Description: PGA target advice report 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 571
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col pga_target_mb format 99,999 heading "Pga |MB"
col pga_target_factor_pct format 9,999 heading "Pga Size|Pct"
col estd_time format 999,999,999 heading "Estimated|Time (s)"
col estd_extra_mb_rw format 99,999,999 heading "Estd extra|MB"
col estd_pga_cache_hit_percentage format 999.99 heading "Estd PGA|Hit Pct"
col estd_overalloc_count format 999,999 heading "Estd|Overalloc"
set pagesize 1000
set lines 100
set echo on 

SELECT ROUND(pga_target_for_estimate / 1048576) pga_target_mb,
       pga_target_factor * 100 pga_target_factor_pct, estd_time,
       ROUND(estd_extra_bytes_rw / 1048576) estd_extra_mb_rw,
       estd_pga_cache_hit_percentage, estd_overalloc_count
FROM v$pga_target_advice
ORDER BY pga_target_factor;
