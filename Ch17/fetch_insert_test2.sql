DROP TABLE opsg_log_data;

CREATE TABLE opsg_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000));

ALTER SYSTEM FLUSH BUFFER_CACHE;
set timing on

DECLARE
   CURSOR newdata_csr IS
      SELECT id, datetime, data
      FROM log_data
      WHERE ROWNUM < &1;
   t_ids          DBMS_SQL.number_table;
   t_datetime     DBMS_SQL.date_table;
   t_data         DBMS_SQL.varchar2_table;
   v_array_size   NUMBER := &2;
BEGIN
   OPEN newdata_csr;

   LOOP
      FETCH newdata_csr
         BULK COLLECT INTO t_ids, t_datetime, t_data
         LIMIT v_array_size;

      FORALL i IN 1 .. t_ids.COUNT
         INSERT INTO opsg_log_data(id, datetime, data)
         VALUES (t_ids(i), t_datetime(i), t_data(i));

      COMMIT;
      EXIT WHEN t_ids.COUNT = 0;
   END LOOP;

   CLOSE newdata_csr;
END;
/

col event format a30

SELECT * FROM my_wait_view;

exit;
/* Formatted on 8/02/2009 5:55:48 PM (QP5 v5.120.811.25008) */
