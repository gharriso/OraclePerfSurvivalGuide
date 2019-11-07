rem *********************************************************** 
rem
rem	File: busy_segments.sql 
rem	Description: Buffer busy waits by segment 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 17 Page 526
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on 
column owner format a20
column object_name format a20
column buffer_busy_count format 999999
column pct format 999.99

SELECT owner, object_name, SUM(VALUE) buffer_busy_count ,
        round(sum(value) * 100/sum(sum(value)) over(),2) pct       
 FROM v$segment_statistics
WHERE statistic_name IN ('gc buffer busy', 'buffer busy waits') 
  AND VALUE > 0
GROUP BY owner, object_name
ORDER BY SUM(VALUE) DESC
/
