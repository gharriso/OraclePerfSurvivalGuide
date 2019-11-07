col event format a30 heading "Wait event"
col total_waits format 999,999,999 heading "Total|Waits"
col time_waited_secs format  999,999,999 heading "Time|(secs)"
col avg_ms format 9,999.99 heading "Avg Wait|(ms)"
set pagesize 1000
set lines 80
set echo on

SELECT event, SUM(total_waits) total_waits,
       ROUND(SUM(time_waited_micro) / 1000000, 2) 
          time_waited_secs,
       ROUND(SUM(time_waited_micro)/1000 /
          SUM(total_waits), 2) avg_ms
FROM gv$system_event
WHERE wait_class <> 'Idle'
      AND(   event LIKE 'gc%block%way'
          OR event LIKE 'gc%multi%'
          or event like 'gc%grant%'
          OR event = 'db file sequential read')
GROUP BY event
HAVING SUM(total_waits) > 0
ORDER BY event;
