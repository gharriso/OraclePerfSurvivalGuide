rem *********************************************************** 
rem
rem	File: asm_operations.sql 
rem	Description: ASM rebalance operations in progress 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 22 Page 647
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col name format a12 heading "Disk Group"
col operation format a10 heading "Operation"
col state format a5 heading "State"
col Power format 999 heading "Power|Reqtd"
col actual format 999 heading "Power|Actual"
col pct_done format 99.99 heading "Pct|Done"
col est_rate format 999 heading "Rate|\Min"
col est_minutes format 999 heading "Estd|Min"
col est_work format 999,999 heading "Estd|Work"
set pagesize 1000
set lines 75
set echo on 

SELECT dg.NAME,  d.operation, d.state, d.POWER, d.actual,
       est_work ,
       d.sofar*100/d.est_work pct_done, d.est_rate, d.est_minutes
  FROM v$asm_diskgroup dg LEFT OUTER JOIN gv$asm_operation d
       ON (d.group_number = dg.group_number); 
