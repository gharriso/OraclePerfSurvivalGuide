/* Formatted on 2008/10/02 07:20 (Formatter Plus v4.8.7) */
SET echo on
 
alter session set tracefile_identifier=bulkCollect; 
alter session set sql_trace true; 
alter session set plsql_optimize_level=2; 

DROP TABLE bulk_collect_tab;
CREATE TABLE bulk_collect_tab NOLOGGING AS
SELECT ROWNUM pk, RPAD(ROWNUM,200,'x') DATA FROM DUAL CONNECT BY ROWNUM < 50000;

insert /*+ append */  into bulk_collect_tab SELECT ROWNUM pk, RPAD(ROWNUM,200,'x') DATA FROM DUAL CONNECT BY ROWNUM < &rows ;
commit; 

CREATE OR REPLACE PROCEDURE bulk_collect
IS
   TYPE numtab_typ IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   TYPE varchartab_typ IS TABLE OF VARCHAR2 (1000)
      INDEX BY PLS_INTEGER;
      
   CURSOR c1 IS
      SELECT pk , data
        FROM   bulk_collect_tab t;
        
   t_pk            numtab_typ;
   t_data          varchartab_typ;
   v_fetch_count   NUMBER := 0;
BEGIN
   OPEN c1;
   LOOP
      FETCH c1 BULK COLLECT INTO   t_pk, t_data LIMIT 100;
      EXIT WHEN t_pk.COUNT = 0;
      v_fetch_count := v_fetch_count + 1;
   END LOOP;
   CLOSE c1;

 
   DBMS_OUTPUT.put_line (v_fetch_count);
END;
/* Formatted on 4-Dec-2008 22:11:18 (QP5 v5.120.811.25008) */

/
/* Formatted on 4-Dec-2008 22:11:09 (QP5 v5.120.811.25008) */
CREATE OR REPLACE PROCEDURE bulk_collect_test (p_array_size NUMBER)
IS
   TYPE numtab_typ IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   TYPE varchartab_typ IS TABLE OF VARCHAR2 (1000)
      INDEX BY PLS_INTEGER;

   CURSOR c1
   IS
      SELECT /*+ cache(t) csr*/
             pk, DATA
        FROM bulk_collect_tab t;

   t_pk            numtab_typ;
   t_data          varchartab_typ;
   v_sum_pk        NUMBER         := 0;
   v_fetch_count   NUMBER         := 0;
   i               NUMBER         := 0;
BEGIN
   IF p_array_size = 0
   THEN
      SELECT /*+ cache(t) bk*/ pk, DATA
      BULK COLLECT INTO t_pk, t_DATA
        FROM bulk_collect_tab t;

      FOR i IN 1 .. t_pk.COUNT
      LOOP
         v_sum_pk := v_sum_pk + t_pk (i);
      END LOOP;
   ELSIF p_array_size = 1
   THEN
      FOR r IN (SELECT /*+ cache(t) */ pk, DATA
                  FROM bulk_collect_tab)
      LOOP
         i := i + 1;
         t_pk (i) := r.pk;
         t_data (i) := r.DATA;
         v_sum_pk := v_sum_pk + t_pk (i);
      END LOOP;
   ELSE
      OPEN c1;

      LOOP
         FETCH c1
         BULK COLLECT INTO t_pk, t_data LIMIT p_array_size;

         EXIT WHEN t_pk.COUNT = 0;
         v_fetch_count := v_fetch_count + 1;

         FOR i IN 1 .. t_pk.COUNT
         LOOP
            v_sum_pk := v_sum_pk + t_pk (i);
         END LOOP;
      END LOOP;

      CLOSE c1;
   END IF;

   DBMS_OUTPUT.put_line (v_sum_pk);
   DBMS_OUTPUT.put_line (v_fetch_count);
END;
/

SET timing on
SET serveroutput on


prompt plsql_optimize_level=2

begin 
    bulk_collect;
end; 
/
exit; 

BEGIN
   bulk_collect_test (0);
END;
/

BEGIN
   bulk_collect_test (0);
END;
/
BEGIN
   bulk_collect_test (1);
END;
/

BEGIN
   bulk_collect_test (1000);
END;
/

alter session set plsql_optimize_level=1 ;
alter procedure bulk_collect_test compile; 
prompt plsql_optimize_level=1

BEGIN
   bulk_collect_test (0);
END;
/
BEGIN
   bulk_collect_test (1);
END;
/

BEGIN
   bulk_collect_test (1000);
END;
/

exit;
