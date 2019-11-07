spool append_test
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

CREATE OR REPLACE VIEW top5_waits_view as 
SELECT  *
     FROM   (SELECT   stat_name, sample_seconds,
                      waits_per_second * sample_seconds waits,
                      microseconds_per_second * sample_seconds micro_wait,
                      RANK () OVER (ORDER BY microseconds_per_second DESC) ranking,
                      ROUND (  microseconds_per_second
                             * 100
                             / SUM (microseconds_per_second) OVER (), 2)
                         pct
               FROM   opsg_delta_report)
    WHERE   ranking <= 20; 



drop table wait_times ; 
create table wait_times (append number,stat_name varchar2(100),micro_wait number); 

COMMIT;


BEGIN
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'SALES');
END;
/

CREATE OR REPLACE PACKAGE append_insert_test IS
   PROCEDURE init;

   function testit(v_append number) return number  ; 
END; -- Package spec
/

CREATE OR REPLACE PACKAGE BODY append_insert_test IS
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
      WHERE ROWNUM < 500000;
   END;

   function  testins(v_append number) return number IS
      v_start_idx      NUMBER := 1;
      v_end_idx        NUMBER := 0;
      v_array_number   NUMBER := 1;
      v_start_time number; 
      v_elapsed_Time number; 
   BEGIN
      v_start_time:=dbms_utility.get_time(); 
      IF v_append=1 THEN
         FORALL i IN 1 .. g_prods.COUNT
            INSERT /*+ append */
                  INTO SALES(PROD_ID, CUST_ID, TIME_ID,
                             CHANNEL_ID, PROMO_ID,
                             QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                    g_promos(i), g_quantities(i), g_amounts(i));
      ELSE
         FORALL i IN 1 .. g_prods.COUNT
            INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
                              QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (g_prods(i), g_custs(i), g_times(i), g_channels(i),
                    g_promos(i), g_quantities(i), g_amounts(i));
      END IF;

      COMMIT;
      insert into wait_times 
        select v_append, stat_name, micro_wait
         from top5_waits_view ; 
      return(dbms_utility.get_time() - v_start_time); 
      
   END;

   FUNCTION testit(v_append number) RETURN NUMBER IS
      t_arraysized   DBMS_SQL.number_table;
      v_start        NUMBER;
      v_ela          NUMBER;
   BEGIN
      init;

      EXECUTE IMMEDIATE 'alter system flush buffer_cache';
      EXECUTE IMMEDIATE 'truncate table sales drop storage';

      v_ela :=testins(v_append);
 
      
      COMMIT;
      return(v_ela); 
   END;
END;
/

set serveroutput on
ALTER SESSION SET tracefile_identifier=append;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
select * from top5_waits_view ; 

DECLARE
    v_append_total number:=0; 
    v_conventional_total number:=0; 
BEGIN 
   append_insert_test.init;

   FOR i IN 1 .. 10 LOOP
      v_append_Total:=v_append_total+append_insert_test.testit(1);

      v_conventional_Total:=v_conventional_total+append_insert_test.testit(0);
   END LOOP;
   dbms_output.put_line('Sum of append='||v_append_total);
   dbms_output.put_line('Sum of conventional='||v_conventional_total);
END;
/

exit;
/* Formatted on 16/01/2009 11:49:55 AM (QP5 v5.120.811.25008) */
