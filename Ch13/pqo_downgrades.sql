set echo on 
column name format a50
set lines 120
set pages 1000
 

SELECT   name,value, round(value*100/sum(value) over(),2) pct
  FROM   v$sysstat
 WHERE   name LIKE 'Parallel operations%downgraded%'; 
 
exit; 
 
