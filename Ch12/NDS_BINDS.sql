/*<TOAD_FILE_CHUNK>*/
/* Formatted on 2008/10/04 16:06 (Formatter Plus v4.8.7) */
CREATE OR REPLACE PACKAGE nds_binds
IS
   FUNCTION matching_rows (
      p_table_name     VARCHAR2,
      p_column_name    VARCHAR2,
      p_column_value   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION matching_rows2 (
      p_table_name     VARCHAR2,
      p_column_name    VARCHAR2,
      p_column_value   VARCHAR2
   )
      RETURN NUMBER;

   PROCEDURE test1 (p_iterations NUMBER);

   PROCEDURE test2 (p_iterations NUMBER);
END;                                                           -- Package spec
/
/* Formatted on 22/07/2009 1:22:05 PM (QP5 v5.115.810.9015) */
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY nds_binds
IS
   FUNCTION matching_rows (p_table_name      VARCHAR2,
                           p_column_name     VARCHAR2,
                           p_column_value    VARCHAR2)
      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      EXECUTE IMMEDIATE   'SELECT COUNT (*) FROM '
                       || p_table_name
                       || ' WHERE '
                       || p_column_name
                       || '='
                       || p_column_value
         INTO   v_count;

      RETURN v_count;
   END;

   FUNCTION matching_rows2 (p_table_name      VARCHAR2,
                            p_column_name     VARCHAR2,
                            p_column_value    VARCHAR2)
      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      EXECUTE IMMEDIATE   'SELECT COUNT (*) FROM '
                       || p_table_name
                       || ' WHERE '
                       || p_column_name
                       || '=:columnValue'
         INTO   v_count
         USING p_column_value;

      RETURN v_count;
   END;

   
   FUNCTION no_binds (p_cust_id NUMBER)
      RETURN NUMBER
   IS
      v_sum   NUMBER;
   BEGIN
      EXECUTE IMMEDIATE 'SELECT SUM(amount_sold) FROM sh.sales WHERE cust_id='
                       || p_cust_id
         INTO   v_sum;

      RETURN (v_sum);
   END;

   FUNCTION use_binds (p_cust_id NUMBER)
      RETURN NUMBER
   IS
      v_sum   NUMBER;
   BEGIN
      EXECUTE IMMEDIATE 'SELECT SUM(amount_sold) FROM sh.sales '
                       || ' WHERE cust_id=:cust_id'
         INTO   v_sum
         USING p_cust_id;

      RETURN (v_sum);
   END;


   PROCEDURE test1 (p_iterations NUMBER)
   IS
      v_number   NUMBER := 0;
   BEGIN
      EXECUTE IMMEDIATE 'alter system flush shared_pool';

      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      FOR i IN 1 .. p_iterations
      LOOP
         v_number :=
            v_number
            + matching_rows ('SH.CUSTOMERS',
                             'CUST_ID',
                             ROUND (DBMS_RANDOM.VALUE (1, 100000)));
      END LOOP;

      DBMS_OUTPUT.put_line ('No binds:' || v_number);
   END;

   PROCEDURE test2 (p_iterations NUMBER)
   IS
      v_number   NUMBER := 0;
   BEGIN
      EXECUTE IMMEDIATE 'alter system flush shared_pool';

      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      FOR i IN 1 .. p_iterations
      LOOP
         v_number :=
            v_number
            + matching_rows2 ('SH.CUSTOMERS',
                              'CUST_ID',
                              ROUND (DBMS_RANDOM.VALUE (1, 100000)));
      END LOOP;

      DBMS_OUTPUT.put_line ('Binds:' || v_number);
   END;
END;
/
/*<TOAD_FILE_CHUNK>*/

SET serveroutput on
SET timing on
SPOOL nds_binds

BEGIN
   nds_binds.test1 (10000);
END;
/
/*<TOAD_FILE_CHUNK>*/

BEGIN
   nds_binds.test2 (10000);
END;
/
/*<TOAD_FILE_CHUNK>*/
@@plsqltime
