CREATE OR REPLACE VIEW my_wait_view AS 
SELECT event, sum(total_waits) total_waits, sum(time_waited_micro) time_waited_micro,
       ROUND(sum(time_waited_micro) * 100 / SUM(sum(time_waited_micro)) OVER (), 2) pct
FROM (SELECT e.sid, event, total_waits, time_waited_micro
        FROM v$session_event e
       WHERE wait_class <> 'Idle'
       UNION
      SELECT sid, stat_name, NULL, VALUE
        FROM v$sess_time_model
       WHERE stat_name IN ('background cpu time', 'DB CPU')) l
WHERE sid in (SELECT sid
              FROM v$session
              WHERE audsid = USERENV('SESSIONID'))
group by event 
ORDER BY 4 DESC; 
