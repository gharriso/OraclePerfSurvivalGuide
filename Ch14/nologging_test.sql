SELECT * FROM TABLE(opsg_pkg.wait_time_report('RESET'));

CREATE OR REPLACE VIEW top_waits_view AS
   SELECT *
   FROM (SELECT CASE
                   WHEN stat_name LIKE 'log%' THEN 'Redo Log IO'
                   WHEN stat_name LIKE 'db file%' THEN 'Conventional IO'
                   WHEN stat_name LIKE 'direct%' THEN 'Direct IO'
                   WHEN stat_name LIKE 'CPU' THEN 'CPU'
                   ELSE 'Other'
                END
                   category, stat_name, sample_seconds,
                waits_per_second * sample_seconds waits,
                microseconds_per_second * sample_seconds micro_wait,
                RANK() OVER (ORDER BY microseconds_per_second DESC) ranking,
                ROUND(  microseconds_per_second
                      * 100
                      / SUM(microseconds_per_second) OVER (), 2)
                   pct
         FROM opsg_delta_report)
   WHERE ranking <= 20;

DROP TABLE wait_data;

CREATE TABLE wait_data (test_mode VARCHAR2(50), category  VARCHAR2(100),
stat_name VARCHAR2(100), micro_wait NUMBER);

DROP TABLE sales_nolog;

CREATE TABLE sales_nolog
NOLOGGING AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

   DROP TABLE sales;

CREATE TABLE sales AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

CREATE OR REPLACE PACKAGE nolog_test IS
   PROCEDURE init;
   PROCEDURE test_nolog;
   PROCEDURE test_log;
   --PROCEDURE test_normal;
   --PROCEDURE test_append;
END;
/


CREATE OR REPLACE PACKAGE BODY nolog_test IS
   g_prods        DBMS_SQL.number_table;
   g_custs        DBMS_SQL.number_table;
   g_times        DBMS_SQL.date_table;
   g_channels     DBMS_SQL.number_table;
   g_promos       DBMS_SQL.number_table;
   g_quantities   DBMS_SQL.number_table;
   g_amounts      DBMS_SQL.number_table;

   PROCEDURE init IS
   BEGIN
      SELECT a.prod_id, a.cust_id, a.time_id, a.channel_id, a.promo_id,
             a.quantity_sold, a.amount_sold
      BULK COLLECT
      INTO g_prods, g_custs, g_times, g_channels, g_promos, g_quantities,
           g_amounts
      FROM sh.sales a
      WHERE ROWNUM < 5000;
   END;

   PROCEDURE test_log IS
      v_start       NUMBER := 1;
      v_end         NUMBER := 0;
      v_batchsize   NUMBER := 100;
   BEGIN
      EXECUTE IMMEDIATE 'truncate table sales_nolog drop storage';

      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      FOR r IN (SELECT * FROM TABLE(opsg_pkg.wait_time_report('RESET'))) LOOP
         NULL;
      END LOOP;

      WHILE v_end < g_prods.COUNT LOOP
         v_end := LEAST(g_prods.COUNT, v_start + v_batchsize-1);
         DBMS_OUTPUT.put_line(v_start || '-' || v_end);

         FORALL i IN v_start .. v_end
            INSERT /*+ APPEND */
                  INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
                                   QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                    g_promos(i), g_quantities(i), g_amounts(i));

         COMMIT;



         v_start := v_start + v_batchsize;
      END LOOP;
         DBMS_LOCK.sleep(5);
      INSERT INTO wait_data
         SELECT 'LOG APPEND', category, stat_name, micro_wait
         FROM top_waits_view;
   END;

   PROCEDURE test_nolog IS
      v_start       NUMBER := 1;
      v_end         NUMBER := 0;
      v_batchsize   NUMBER := 100;
   BEGIN
      EXECUTE IMMEDIATE 'truncate table sales_nolog drop storage';

      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      FOR r IN (SELECT * FROM TABLE(opsg_pkg.wait_time_report('RESET'))) LOOP
         NULL;
      END LOOP;

      WHILE v_end < g_prods.COUNT LOOP
         v_end := LEAST(g_prods.COUNT, v_start + v_batchsize-1);
         DBMS_OUTPUT.put_line(v_start || '-' || v_end);

         FORALL i IN v_start .. v_end
            INSERT /*+ APPEND */
                  INTO SALES_nolog(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
                                   QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                    g_promos(i), g_quantities(i), g_amounts(i));

         COMMIT;



         v_start := v_start + v_batchsize;
      END LOOP;
         DBMS_LOCK.sleep(5);
      INSERT INTO wait_data
         SELECT 'NOLOG APPEND', category, stat_name, micro_wait
         FROM top_waits_view;
   END;
END;



BEGIN
   nolog_test.init;
END;



BEGIN
   FOR i IN 1 .. 3 LOOP
      --nolog_test.test_normal;
      --nolog_test.test_append;
      nolog_test.test_nolog;
      nolog_test.test_log;
   END LOOP;
END;
/

COMMIT;


SELECT * FROM wait_data order by micro_wait; 
/* Formatted on 17/01/2009 12:44:21 PM (QP5 v5.120.811.25008) */
