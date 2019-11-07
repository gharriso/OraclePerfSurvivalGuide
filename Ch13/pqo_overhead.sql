WITH db_cpu AS (SELECT   dop, seq, time_micro
                  FROM   pqo_scale_test_waits
                 WHERE   event = 'DB CPU'),
    elapsed AS (  SELECT   requested_dop dop, AVG (elapsed) elapsed
                    FROM   pqo_scale_test
                GROUP BY   requested_dop)
  SELECT   cpu.dop, round(avg(cpu.time_micro - prev_cpu.time_micro)) cpu_delta,
   min(elapsed)
    FROM      db_cpu cpu
           JOIN
              db_cpu prev_cpu
           ON (prev_cpu.seq = cpu.seq - 1)
           join elapsed on (cpu.dop=elapsed.dop) 
group by cpu.dop            
ORDER BY   cpu.dop
/* Formatted on 28/12/2008 8:12:56 PM (QP5 v5.120.811.25008) */
