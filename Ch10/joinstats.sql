column name format a35
column value format 999,999,999
set echo on 
 
SELECT NAME, VALUE
  FROM v$sysstat
 WHERE NAME LIKE 'workarea executions - %'
    OR NAME IN ('sorts (memory)', 'sorts (disk)');

