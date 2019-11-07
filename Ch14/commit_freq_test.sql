spool commit_test
set echo on
set pages 1000
set lines 120
set serveroutput on
set timing on
DROP TABLE sales;

CREATE TABLE sales AS
   SELECT *
   FROM sh.sales
   WHERE 0 = 1;

DROP TABLE commit_test_data;

CREATE TABLE commit_test_data (commit_interval NUMBER, elapsed        NUMBER);

COMMIT;


BEGIN
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'SALES');
END;
/

CREATE OR REPLACE PACKAGE commit_freq_test IS
   PROCEDURE init;

   PROCEDURE testit;
END;
/

CREATE OR REPLACE PACKAGE BODY commit_freq_test IS
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
      WHERE ROWNUM < 50000;
   END;

   FUNCTION testins(v_commit_int NUMBER)
      RETURN NUMBER IS
      v_start_idx      NUMBER := 1;
      v_end_idx        NUMBER := 0;
      v_array_number   NUMBER := 1;
      v_start_time     NUMBER;
      v_elapsed_Time   NUMBER;
   BEGIN
      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      EXECUTE IMMEDIATE 'truncate table sales drop storage';

      v_start_time := DBMS_UTILITY.get_time();

      FOR i IN 1 .. g_prods.LAST LOOP
         INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
                           QUANTITY_SOLD, AMOUNT_SOLD)
         VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                 g_promos(i), g_quantities(i), g_amounts(i));

         IF MOD(i, v_commit_int) = 0 THEN
            COMMIT;
         END IF;
      END LOOP;

      RETURN (DBMS_UTILITY.get_time() - v_start_time);
   END;

   PROCEDURE testit IS
      t_arraysized   DBMS_SQL.number_table;
      v_commit_int   NUMBER;
      v_ela          NUMBER;
   BEGIN
      init;
      v_commit_int := 1;

      WHILE v_commit_int < 1000 LOOP
         v_ela := testins(v_commit_int);

         INSERT INTO commit_test_data
         VALUES (v_commit_int, v_ela);

         COMMIT;
         IF v_commit_int > 100 THEN
            v_commit_int := v_commit_int + 50;
         ELSIF v_commit_int > 50 THEN
            v_commit_int := v_commit_int + 10;
         ELSIF v_commit_int > 10 THEN
            v_commit_int := v_commit_int + 5;
         ELSE
            v_commit_int := v_commit_int + 1;
         END IF;
      END LOOP;
   END;
END;
/

set serveroutput on
ALTER SESSION SET tracefile_identifier=append;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';



DECLARE
   v_append_total         NUMBER := 0;
   v_conventional_total   NUMBER := 0;
BEGIN
   commit_freq_test.testit();
END;
/

exit;
/* Formatted on 16/01/2009 9:12:25 PM (QP5 v5.120.811.25008) */
