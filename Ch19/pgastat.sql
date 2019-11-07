col name format a40
col value format 999,999,999,999
col unit format a10
set lines 100
set pages 1000
set echo on

SELECT * FROM v$pgastat;

