/* Formatted on 2008/11/22 13:51 (Formatter Plus v4.8.7) */
WITH mysid AS
     (SELECT /*+ materialize */
             SID
        FROM v$session
       WHERE audsid = USERENV ('sessionid'))
SELECT   event, total_waits, time_waited_micro
    FROM v$session_event JOIN mysid USING (SID)
   WHERE wait_class <> 'Idle'
UNION
SELECT   stat_name, NULL, VALUE
    FROM v$sess_time_model JOIN mysid USING (SID)
ORDER BY 3 DESC

