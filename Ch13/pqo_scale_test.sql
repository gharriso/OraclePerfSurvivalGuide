spool pqo_scaling
set echo on
set pages 1000
set lines 120
set serveroutput on
ROLLBACK;
ALTER SESSION ENABLE PARALLEL DML;
DROP TABLE sales_archive;

CREATE TABLE sales_archive AS
   SELECT   * FROM sh.sales;

BEGIN
   FOR i IN 1 .. 5 LOOP
      INSERT /*+parallel (sa,4) append */
            INTO sales_archive sa
         SELECT /*+parallel (s,4) */
                *  FROM sh.sales;

      COMMIT;
   END LOOP;
END;
/
DROP TABLE pqo_scale_test;

CREATE TABLE pqo_scale_test (requested_dop NUMBER, actual_dop   NUMBER,
elapsed      NUMBER,busy_time number, idle_time number );

DECLARE
   sql1              VARCHAR2 (200) := 'select /*+ parallel(sa,';
   sql2 VARCHAR2 (200)
         := ') */ prod_id,sum(quantity_sold), sum(amount_sold)
                         from sales_archive sa
                       group by prod_id
                        order by 3 desc ';
   t_prod_id         DBMS_SQL.number_table;
   t_quantity_sold   DBMS_SQL.number_table;
   t_amount_sold     DBMS_SQL.number_table;

   TYPE cv_type IS REF CURSOR;

   CV                cv_type;
   v_start_time      NUMBER;
   v_end_time        NUMBER;
   v_real_dop        NUMBER;
BEGIN
   FOR dop IN 1 .. 20 LOOP
      v_start_time := DBMS_UTILITY.get_time ();

      OPEN CV FOR sql1 || dop || sql2;

      FETCH CV BULK COLLECT INTO   t_prod_id, t_quantity_sold, t_amount_sold;

      CLOSE CV;

      v_end_time := DBMS_UTILITY.get_time ();

      DBMS_LOCK.sleep (5);

        SELECT   MAX (COUNT (DISTINCT process))
          INTO   v_real_dop
          FROM   v$pq_tqstat t
         WHERE   dfo_number = (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
                 AND server_type LIKE 'Producer%'
      GROUP BY   tq_id, server_type;

      INSERT INTO pqo_scale_test (requested_dop, actual_dop, elapsed)
        VALUES   (dop, v_real_dop, (v_end_time - v_start_time));

      COMMIT;
   END LOOP;
END;
/

SELECT   * FROM pqo_scale_test;
exit
/* Formatted on 24/12/2008 9:35:07 AM (QP5 v5.120.811.25008) */
