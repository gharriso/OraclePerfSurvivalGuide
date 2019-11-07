rem *********************************************************** 
rem
rem	File: pga_advice_hist.sql 
rem	Description: PGA target advice histogram 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 572
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
column estd_target_pct format 9,999 heading "Rel|Size %"
column extra_bytes_histogram format a60 heading "Relative Extra Bytes RW"

SELECT ROUND(PGA_TARGET_FOR_ESTIMATE / 1048576) size_mb,
       ROUND(PGA_TARGET_FACTOR * 100, 2) estd_target_pct,
       RPAD(' ',
       ROUND(ESTD_EXTRA_BYTES_RW / MAX(ESTD_EXTRA_BYTES_RW) OVER () * 60),
       DECODE(PGA_TARGET_FACTOR,
              1, '=',
              DECODE(SIGN(estd_overalloc_count), 1, 'x', '*')))
          extra_bytes_histogram
FROM v$pga_target_advice
ORDER BY 1 DESC;
