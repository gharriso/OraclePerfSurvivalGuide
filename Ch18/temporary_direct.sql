rem *********************************************************** 
rem
rem	File: temporary_direct.sql 
rem	Description: Direct path IO and buffered IO
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 18 Page 538
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 100
col name format a31
col value format 99,999,999 heading "Count"
col pct_of_physical format 999.99 heading "Pct of|Phys Rds"
col pct_of_direct format 999.99 heading "Pct of|Direct Rds"
set echo on

WITH sysstat AS
       (SELECT name, VALUE,
               SUM(DECODE(name, 'physical reads', VALUE)) OVER ()
                  total_phys_reads,
               SUM(DECODE(name, 'physical reads direct', VALUE))
                  OVER ()
                  tot_direct_reads
        FROM v$sysstat
        WHERE name IN
                    ('physical reads',
                     'physical reads direct',
                     'physical reads direct temporary tablespace'))
SELECT name, VALUE, 
       ROUND(VALUE * 100 / total_phys_reads, 2) pct_of_physical,
       decode(name,'physical reads',0,
              ROUND(VALUE * 100 / tot_direct_reads, 2)) pct_of_direct
FROM sysstat
/

