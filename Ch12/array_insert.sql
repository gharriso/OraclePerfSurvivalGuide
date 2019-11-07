DROP TABLE bulk_collect_tab;

CREATE TABLE bulk_collect_tab (pk  NUMBER, data VARCHAR2 (1000))
NOLOGGING;

CREATE OR REPLACE PACKAGE array_insert
IS
   PROCEDURE init (p_rows NUMBER);

   PROCEDURE insert_all;

   PROCEDURE insert_batch;

   PROCEDURE insert_nobatch;

   PROCEDURE truncate_tab;

   PROCEDURE insert_batch_indices;
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY array_insert
IS
   t_pk     DBMS_SQL.number_table;
   t_data   DBMS_SQL.varchar2_table;

   PROCEDURE init (p_rows NUMBER)
   IS
   BEGIN
      t_pk.delete;
      t_data.delete;

      FOR i IN 1 .. p_rows
      LOOP
         t_pk (i) := i;
         t_data (i) := RPAD ('x', 200, 'x');
      END LOOP;
   END;

   PROCEDURE truncate_tab
   IS
   BEGIN
      EXECUTE IMMEDIATE 'truncate table bulk_collect_tab';
   END;

   PROCEDURE insert_all
   IS
   BEGIN
      FORALL idx IN t_pk.FIRST .. t_pk.LAST
         INSERT INTO bulk_collect_tab (pk, data)
           VALUES   (t_pk (idx), t_data (idx));

      COMMIT;
   END;

   PROCEDURE insert_nobatch
   IS
   BEGIN
      FOR idx IN t_pk.FIRST .. t_pk.LAST
      LOOP
         INSERT INTO bulk_collect_tab (pk, data)
           VALUES   (t_pk (idx), t_data (idx));
      END LOOP;

      COMMIT;
   END;

   PROCEDURE insert_batch
   IS
      idx   PLS_INTEGER;
   BEGIN
      idx := t_pk.FIRST;

      WHILE idx <= t_pk.LAST
      LOOP
         FORALL i IN idx .. LEAST (idx + 100, t_pk.LAST)
            INSERT INTO bulk_collect_tab (pk, data)
              VALUES   (t_pk (i), t_data (i));

         idx := idx + 101;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE insert_batch_indices
   IS
      idx   PLS_INTEGER;
   BEGIN
      FORALL idx IN INDICES OF t_pk
         INSERT INTO bulk_collect_tab (pk, data)
           VALUES   (t_pk (idx), t_data (idx));


      COMMIT;
   END;
END;
/

set echo on
spool array_insert2
set timing on
ALTER SESSION SET tracefile_identifier=array_insert;

BEGIN
   DBMS_SESSION.session_trace_enable (waits => TRUE, binds => FALSE);
END;
/

BEGIN
   array_insert.init (&rows);
END;
/

BEGIN
   array_insert.truncate_tab;
END;
/

BEGIN
   array_insert.insert_all;
END;
/


SELECT   COUNT ( * ) FROM bulk_collect_tab;

BEGIN
   array_insert.truncate_tab;
END;
/

BEGIN
   array_insert.insert_batch;
END;
/

SELECT   COUNT ( * ) FROM bulk_collect_tab;

/

BEGIN
   array_insert.truncate_tab;
END;
/

BEGIN
   array_insert.insert_nobatch;
END;
/

BEGIN
   array_insert.truncate_tab;
END;
/

BEGIN
   array_insert.insert_batch_indices;
END;
/

SELECT   COUNT ( * ) FROM bulk_collect_tab;

exit;
/* Formatted on 7-Dec-2008 21:48:07 (QP5 v5.120.811.25008) */
