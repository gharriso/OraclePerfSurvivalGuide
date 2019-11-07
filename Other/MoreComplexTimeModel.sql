/* Formatted on 2008/07/22 13:37 (Formatter Plus v4.8.7) */
WITH time_model AS
     (
        SELECT /*+materialize*/
               SUM(CASE
                      WHEN stat_name IN ('DB time', 'background cpu time')
                         THEN VALUE END
                  ) AS cpu_time,
               SUM
                  (CASE
                      WHEN stat_name IN
                                       ('background elapsed time', 'DB time')
                         THEN VALUE
                   END
                  ) AS elapsed_time
          FROM v$sys_time_model),
     wait_interface AS
     (SELECT /*+materialize*/
             event, total_waits, time_waited_micro
        FROM v$system_event
       WHERE wait_class <> 'Idle')
SELECT   event, total_waits, time_waited_micro,
         ROUND (time_waited_micro * 100 / elapsed_time, 2)
    FROM (SELECT event, total_waits, time_waited_micro
            FROM wait_interface
          UNION
          SELECT 'CPU', NULL, cpu_time
            FROM time_model
            UNION 
            select 'OTHER',null,elapsed_time-cpu_time-total_wait_time
              from time_model cross join (select sum(time_waited_micro) total_wait_time from wait_interface))
         CROSS JOIN
         time_model
ORDER BY 3 DESC

