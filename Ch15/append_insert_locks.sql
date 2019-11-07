alter session set tracefile_identifier=append_locks;
alter session set events '10046 trace name context forever, level 8'; 
set pages 1000

prompt loops=&1
prompt batch=&2

CREATE TABLE sales_stage AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

set timing on 

DECLARE
   t_prods      DBMS_SQL.number_table;
   t_custs      DBMS_SQL.number_table;
   t_times      DBMS_SQL.date_table;
   t_promos     DBMS_SQL.number_table;
   t_channels   DBMS_SQL.number_table;
   t_q_solds    DBMS_SQL.number_table;
   t_a_solds    DBMS_SQL.number_table;
BEGIN
   SELECT a.prod_id, a.cust_id, a.time_id, a.channel_id, a.promo_id,
          a.quantity_sold, a.amount_sold
   BULK COLLECT
   INTO t_prods, t_custs, t_times, t_channels, t_promos, t_q_solds, t_a_solds
   FROM sh.sales a
   WHERE ROWNUM <= &2;

   FOR i IN 1 .. &1 LOOP
      NULL;

      FORALL j IN 1 .. t_prods.COUNT
         INSERT /*+ APPEND */
               INTO sales_stage(prod_id, cust_id, time_id,
                                channel_id, promo_id,
                                quantity_sold, amount_sold)
         VALUES (t_prods(j), t_custs(j), t_times(j), t_channels(j),
                 t_promos(j), t_q_solds(j), t_a_solds(j));
         commit; 
   END LOOP;
END;
/

column event format a30
column time_waited_ms format 999,999
column total_waits format 999,999
column pct format 99.99 

SELECT event, total_waits,time_waited_micro / 1000 time_waited_ms,
       ROUND(time_waited_micro * 100 / SUM(time_waited_micro) OVER (), 2) pct
FROM v$session_event
WHERE wait_class <> 'Idle'
      AND sid = (SELECT sid
                 FROM v$session
                 WHERE USERENV('sessionid') = audsid)
ORDER BY time_waited_micro;
/* Formatted on 27/01/2009 5:00:43 PM (QP5 v5.120.811.25008) */

truncate table sales_stage drop storage; 
