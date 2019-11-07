DROP TABLE opsg_log_data;

CREATE TABLE opsg_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000));

DECLARE
   CURSOR newdata_csr IS
      SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
             RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
      FROM DUAL
      CONNECT BY ROWNUM < &1;
   t_ids        DBMS_SQL.number_table;
   t_datetime   DBMS_SQL.date_table;
   t_data       DBMS_SQL.varchar2_table;
   v_array_size number:=&2; 
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

select * from my_wait_view; 

exit;
