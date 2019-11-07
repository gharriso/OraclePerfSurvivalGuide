WITH times AS (SELECT   dop,seq ,"'User I/O'"  user_io,"'DB CPU'" db_cpu,"'DB time'" db_time,"'System I/O'" system_io
  FROM   (  SELECT   dop, seq, NVL (wait_class, event) category,
                     SUM (time_micro) time_micro
              FROM      pqo_scale_test_waits
                     LEFT OUTER JOIN
                        v$event_name
                     ON (event = name)
          GROUP BY   dop, seq, NVL (wait_class, event))
  PIVOT
(SUM(time_micro) FOR category IN ('User I/O','DB CPU','DB time','System I/O' )) )
  SELECT   t.dop, ROUND (AVG (t.db_time - prev.db_time)) db_time_delta,
   ROUND(AVG(t.db_cpu-prev.db_cpu)) db_cpu_delta ,
   round(avg(t.system_io-prev.system_io)) system_io_delta,
    round(avg(t.user_io-prev.user_io)) user_io_delta
    FROM      times t
           JOIN
              times prev
           ON (prev.seq = t.seq - 1)
GROUP BY   t.dop
ORDER BY   t.dop
/* Formatted on 28/12/2008 7:46:19 PM (QP5 v5.120.811.25008) */
