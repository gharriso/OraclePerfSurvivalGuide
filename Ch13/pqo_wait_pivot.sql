SELECT   dop,seq ,"'User I/O'"  user_io,"'DB CPU'" db_cpu,"'DB time'" db_time,"'System I/O'" system_io
  FROM   (  SELECT   dop, seq, NVL (wait_class, event) category,
                     SUM (time_micro) time_micro
              FROM      pqo_scale_test_waits
                     LEFT OUTER JOIN
                        v$event_name
                     ON (event = name)
          GROUP BY   dop, seq, NVL (wait_class, event))
  PIVOT
(SUM(time_micro) FOR category IN ('User I/O','DB CPU','DB time','System I/O' ))
order by seq 
          
/* Formatted on 28/12/2008 7:39:10 PM (QP5 v5.120.811.25008) */
