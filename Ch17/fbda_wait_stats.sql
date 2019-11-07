column stat_name  format a30
column total_waits format 999,999,999
column wait_ms format 999,999,999
column pct_time format 99.99 

set echo on 

WITH sess_waits AS 
        (SELECT sid, stat_name , NULL total_waits,
                VALUE time_waited_micro
           FROM v$sess_time_model
          WHERE stat_name IN ('background cpu time', 'DB CPU')
          UNION
         SELECT sid, event, total_waits, time_waited_micro
           FROM v$session_event
          WHERE wait_class <> 'Idle'),
     fbda_sid AS 
        (SELECT sid
           FROM v$bgprocess p JOIN v$session USING (paddr)
          WHERE p.name = 'FBDA')
SELECT stat_name, total_waits, 
       ROUND(time_waited_micro / 1000) wait_ms,
       ROUND(time_waited_micro * 100 / SUM(time_waited_micro) 
              OVER (), 2)  pct_time
  FROM sess_waits JOIN fbda_sid USING (sid)
ORDER BY time_waited_micro DESC
; 
