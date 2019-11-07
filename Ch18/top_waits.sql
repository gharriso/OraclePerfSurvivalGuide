set echo on 
set pages 1000
set lines 100
col event format a30

WITH wait_times AS (SELECT event, total_waits, time_waited_micro,
                           ROUND(  time_waited_micro * 100
                           /SUM(time_waited_micro) OVER(),2) AS pct
                    FROM v$system_event
                    WHERE wait_class <> 'Idle')
SELECT *
  FROM wait_times
 WHERE pct > 1
 ORDER BY pct DESC
/

