SELECT TYPE, name, total_req# gets, total_wait# waits,
       cum_wait_time wait_time,
       round(total_req# * 100 / SUM(total_req#) OVER () ,2) pct_gets,
       round(cum_wait_time * 100 / SUM(cum_wait_time) OVER () ,2) pct_time 
FROM    v$enqueue_stat s
     JOIN
        v$lock_type t
     ON (s.eq_type = t.TYPE)
ORDER BY  total_wait# desc 
/* Formatted on 20-Jan-2009 20:40:10 (QP5 v5.120.811.25008) */
