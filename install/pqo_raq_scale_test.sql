spool rac_scaling
set echo on
set pages 1000
set lines 120
set serveroutput on
ROLLBACK;
ALTER SESSION ENABLE PARALLEL DML;
ALTER SYSTEM SET parallel_threads_per_cpu=20  SCOPE=MEMORY;
ALTER SYSTEM SET parallel_min_servers=40 SCOPE=MEMORY; 
ALTER SYSTEM SET parallel_max_servers=40 SCOPE=MEMORY; 
 
DROP TABLE sales_archive;

CREATE TABLE sales_archive AS
   SELECT   * FROM sh.sales;


/

DROP TABLE pqo_scale_test;

CREATE TABLE pqo_scale_test (requested_dop NUMBER, actual_dop   NUMBER, seq          NUMBER,
elapsed      NUMBER, busy_time    NUMBER, idle_time    NUMBER, instances number);

CREATE OR REPLACE PACKAGE pqo_test IS
   TYPE osstat_typ IS
      TABLE OF NUMBER
         INDEX BY sys.v_$osstat.stat_name%TYPE;

   PROCEDURE scale_test (p_max_dop NUMBER, p_iterations NUMBER);

   FUNCTION osstats_deltas
      RETURN osstat_typ;

   PROCEDURE populate_table (p_load_count NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY pqo_test IS
   g_last_osstats   osstat_typ;

   FUNCTION osstats_deltas
      RETURN osstat_typ IS
      t_stat_names      DBMS_SQL.varchar2_table;
      t_stat_values     DBMS_SQL.number_table;
      t_osstats         osstat_typ;
      t_osstats_delta   osstat_typ;
      v_stat_name       v$osstat.stat_name%TYPE;
   BEGIN
      SELECT   stat_name, VALUE
        BULK   COLLECT
        INTO   t_stat_names, t_stat_values
        FROM   v$osstat;

      FOR i IN 1 .. t_stat_names.COUNT () LOOP
         t_osstats (t_stat_names (i)) := t_stat_values (i);
      END LOOP;

      IF g_last_osstats.COUNT () > 0 THEN
         v_stat_name := g_last_osstats.FIRST ();

         WHILE (v_stat_name IS NOT NULL) LOOP
            t_osstats_delta (v_stat_name) :=
               t_osstats (v_stat_name) - g_last_osstats (v_stat_name);
            v_stat_name := g_last_osstats.NEXT (v_stat_name);
         END LOOP;
      END IF;
      g_last_osstats := t_osstats;
      RETURN (t_osstats_delta);
   END;

   PROCEDURE populate_table (p_load_count NUMBER) IS
   BEGIN
      FOR i IN 1 .. p_load_count LOOP
         INSERT /*+parallel (sa,4) append */
               INTO sales_archive sa
            SELECT /*+parallel (s,4) */
                   *  FROM sh.sales;

         COMMIT;
      END LOOP;
   END;

   PROCEDURE scale_test (p_max_dop NUMBER, p_iterations NUMBER) IS
      sql1              VARCHAR2 (200) := 'select  ';
      sql2 VARCHAR2 (200)
            := ' prod_id,quantity_sold, amount_sold
                         from sales_archive sa
                       order by 1,2,3 ';
      t_prod_id         DBMS_SQL.number_table;
      t_quantity_sold   DBMS_SQL.number_table;
      t_amount_sold     DBMS_SQL.number_table;

      TYPE cv_type IS REF CURSOR;

      CV                cv_type;
      v_start_time      NUMBER;
      v_end_time        NUMBER;
      v_real_dop        NUMBER;
      t_osdeltas        osstat_typ;
      v_hint            VARCHAR2 (100);
      v_instances number; 
   BEGIN
      --t_osdeltas := osstats_deltas ();

      FOR iteration IN 1 .. p_iterations LOOP
         FOR dop IN 1 .. p_max_dop LOOP
            --t_osdeltas := osstats_deltas ();
            v_start_time := DBMS_UTILITY.get_time ();

            IF dop > 1 THEN
               v_hint := ' /*+ parallel(sa,' || dop || ') */';
            ELSE
               v_hint := ' /*+ no_parallel */ ';
            END IF;

            OPEN CV FOR sql1 || v_hint || sql2;

            FETCH CV
               BULK COLLECT INTO   t_prod_id, t_quantity_sold, t_amount_sold limit 10000;

            CLOSE CV;

            v_end_time := DBMS_UTILITY.get_time ();

            t_osdeltas := osstats_deltas ();
            DBMS_LOCK.sleep (5);
              SELECT   MAX (COUNT (DISTINCT process)),count(distinct instance) instances
                INTO   v_real_dop,v_instances
                FROM   v$pq_tqstat t
               WHERE   dfo_number =
                          (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
                       AND server_type LIKE 'Producer%'
            GROUP BY   tq_id, server_type,instance;



            INSERT INTO pqo_scale_test (
                                           requested_dop,
                                           actual_dop,
                                           seq,
                                           elapsed,
                                           busy_time,
                                           idle_time, instances
                       )
              VALUES   (
                           dop, v_real_dop, iteration,
                           (v_end_time - v_start_time),
                           NULL,
                          NULL, v_instances
                       );

            COMMIT;
         END LOOP;
      END LOOP;
   END;
END;
/
BEGIN
   pqo_test.populate_table (4);
   pqo_test.scale_test (20,3);
END;
/

 
  
  select * from pqo_scale_test order by seq,requested_dop; 
exit
/* Formatted on 26/12/2008 8:26:16 AM (QP5 v5.120.811.25008) */
