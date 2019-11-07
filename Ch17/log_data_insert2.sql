DROP TABLE opsg_log_data;

CREATE TABLE opsg_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000));

CREATE OR REPLACE PACKAGE log_data_insert IS
   PROCEDURE insert_log(v_rows NUMBER, v_append    BOOLEAN := FALSE);
END;
/

CREATE OR REPLACE PACKAGE BODY log_data_insert IS
   PROCEDURE add_log_data(t_ids          IN OUT NOCOPY DBMS_SQL.number_table,
                          t_datetime     IN OUT NOCOPY DBMS_SQL.date_table,
                          t_data         IN OUT NOCOPY DBMS_SQL.varchar2_table,
                          v_batch_size                 NUMBER:= 1000,
                          v_append                     BOOLEAN:= FALSE) IS
      v_start_id   NUMBER;
      v_end_id     NUMBER;
   BEGIN
      v_start_id := 1;
      v_end_id := LEAST(v_start_id + v_batch_size - 1, t_ids.COUNT);

      LOOP
         DBMS_OUTPUT.put_line('start ' || v_start_id || ' end: ' || v_end_id);

         IF v_append THEN
            FORALL i IN v_start_id .. v_end_id
               INSERT /*+ append */
                     INTO opsg_log_data(id, datetime, data)
               VALUES (t_ids(i), t_datetime(i), t_data(i));
            commit; 
         ELSE
            FORALL i IN v_start_id .. v_end_id
               INSERT INTO opsg_log_data(id, datetime, data)
               VALUES (t_ids(i), t_datetime(i), t_data(i));
            commit; 
         END IF;

         EXIT WHEN v_end_id = t_ids.COUNT;
         v_start_id := v_end_id + 1;
         v_end_id := LEAST(v_start_id + v_batch_size - 1, t_ids.COUNT);
      END LOOP;
   END;

   PROCEDURE insert_log(v_rows      NUMBER,
                        v_append    BOOLEAN := FALSE) IS
      t_id         DBMS_SQL.number_table;
      t_datetime   DBMS_SQL.date_table;
      t_data       DBMS_SQL.varchar2_table;
      v_start_id   NUMBER;
   BEGIN
      SELECT MAX(id) INTO v_start_id FROM opsg_log_data;

      FOR i IN 1 .. v_rows LOOP
         t_id(i) := NVL(v_start_id, 0) + i;
         t_datetime(i) := SYSDATE - DBMS_RANDOM.VALUE(1, 1000);
         t_data(i) := t_datetime(i) || RPAD('x', 800, 'x');
      END LOOP;

      add_log_data(t_id, t_datetime, t_data, 10000, v_append);
   END;
END;
/

ALTER SESSION SET tracefile_identifier=log_insert;

BEGIN
   DBMS_SESSION.session_trace_enable(waits => TRUE, binds => FALSE);
END;
/

BEGIN
   Log_data_insert.insert_log(&1,&2);
END;
/

COMMIT;
col event format a30

SELECT * FROM my_wait_view;
/* Formatted on 8-Feb-2009 14:45:45 (QP5 v5.120.811.25008) */
