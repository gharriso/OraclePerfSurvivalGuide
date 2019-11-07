rem *********************************************************** 
rem
rem	File: hit_rate_delta.sql 
rem	Description: """hit rates"" calculated over a  time interval "
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 542
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 80
column category format a12 heading "Category"
column db_block format 99,999,999 heading "DB Block|Gets"
column consistent format 99,999,999 heading "Consistent|Gets"
column physical format 99,999,999 heading "Physical|Gets"
column  hit_rate format 99.99 heading "Hit|Rate"
column sample_seconds format 99999 heading "Sample|Seconds"
set echo on 

select * from hit_rate_delta_view ; 
