DROP TABLE sales;

CREATE TABLE sales
 AS
   SELECT *
   FROM sh.sales
   WHERE 0 = 1;

DROP TABLE array_insert_data;

COMMIT;

CREATE TABLE array_insert_data (seq         NUMBER,
array_size  NUMBER, microseconds NUMBER);

CREATE OR REPLACE PACKAGE array_insert_test IS
   PROCEDURE init;

   PROCEDURE testit;

   PROCEDURE testins(seq            NUMBER,
                     v_arraysize    NUMBER);
END; -- Package spec
/

CREATE OR REPLACE PACKAGE BODY array_insert_test IS
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
      WHERE ROWNUM < 20000;
   END;

   PROCEDURE testins(seq            NUMBER,
                     v_arraysize    NUMBER) IS
      v_start_idx      NUMBER := 1;
      v_end_idx        NUMBER := 0;
      v_array_number   NUMBER := 1;
   BEGIN
      IF v_arraysize = 1 THEN
         FOR i IN 1 .. g_prods.LAST LOOP
            INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
                              QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                    g_promos(i), g_quantities(i), g_amounts(i));
         END LOOP;
      ELSE
        <<ins_loop>>
         LOOP
            v_end_idx := v_end_idx + v_arraysize;
            v_end_idx := LEAST(v_end_idx + v_arraysize - 1, g_prods.LAST);

            -- DBMS_OUTPUT.put_line(v_start_idx ||'-'||v_end_idx);

            FORALL i IN v_start_idx .. v_end_idx
               INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID,
                                 PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
               VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                       g_promos(i), g_quantities(i), g_amounts(i));


            IF v_end_idx = g_prods.LAST THEN
               EXIT ins_loop;
            END IF;
            IF v_array_number * v_arraysize > 200000 THEN
               EXIT;
            END IF;
            v_start_idx := v_start_idx + v_arraysize;
            v_array_number := v_array_number + 1;
         END LOOP;
      END IF;
      COMMIT;
   END;

   PROCEDURE testit IS
      t_arraysized   DBMS_SQL.number_table;
      v_start        NUMBER;
      v_ela          NUMBER;
   BEGIN
      t_arraysized(1) := 1;
      t_arraysized(2) := 2;
      t_arraysized(3) := 5;
      t_arraysized(4) := 7;
      t_arraysized(5) := 10;
      t_arraysized(6) := 15;
      t_arraysized(7) := 20;
      t_arraysized(8) := 50;
      t_arraysized(9) := 75;
      t_arraysized(10) := 100;
      t_arraysized(11) := 150;
      t_arraysized(12) := 200;
      t_arraysized(13) := 250;
      t_arraysized(14) := 500;
      t_arraysized(15) := 10000;


      init;

      FOR i IN 1 .. t_arraysized.COUNT LOOP
         EXECUTE IMMEDIATE 'alter system flush buffer_cache';

         EXECUTE IMMEDIATE 'truncate table sales drop storage';

         v_start := DBMS_UTILITY.get_time();
         testins(i, t_arraysized(i));
         v_ela := DBMS_UTILITY.get_time() - v_start;

         INSERT INTO array_insert_data(seq, array_size, microseconds)
         VALUES (i, t_arraysized(i), v_ela);

         COMMIT;
      END LOOP;
   END;
END;
/

BEGIN
   array_insert_test.testit;
END;
/

SELECT * FROM array_insert_data;

SELECT COUNT( * ) FROM sales;

exit;
/* Formatted on 15/01/2009 9:53:44 PM (QP5 v5.120.811.25008) */
