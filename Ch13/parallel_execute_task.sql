REM DROP TABLE sales;
CREATE TABLE sales AS
   SELECT * FROM sh.sales;
ALTER TABLE sales ADD unit_price number;

DECLARE
   v_dml_sql     VARCHAR2(1000);
   v_task_name   VARCHAR2(1000) := 'dbms_parallel_execute demo';
   v_status      NUMBER;
BEGIN
   DBMS_PARALLEL_EXECUTE.CREATE_TASK(task_name => v_task_name);

   DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID(TASK_NAME => v_task_name, 
        TABLE_OWNER => USER, TABLE_NAME => 'SALES', 
        BY_ROW => TRUE, CHUNK_SIZE => 1000);

   v_dml_sql :=
         'UPDATE sales SET   unit_price = '
      || '        amount_sold / quantity_sold '
      || ' WHERE rowid BETWEEN :start_id AND :end_id ';

   DBMS_PARALLEL_EXECUTE.RUN_TASK(TASK_NAME => v_task_name,
        SQL_STMT => v_dml_sql, LANGUAGE_FLAG => DBMS_SQL.NATIVE, 
        PARALLEL_LEVEL => 2);

   v_status := DBMS_PARALLEL_EXECUTE.TASK_STATUS(task_name => v_task_name);

   IF v_status = DBMS_PARALLEL_EXECUTE.FINISHED THEN
      DBMS_PARALLEL_EXECUTE.DROP_TASK(task_name => v_task_name);
   ELSE
      -- could use dbms_parallel_execute.resume_task here to retry if required
      raise_application_error(-2001,
      'Task ' || v_task_name || ' abnormal termination: status=' || v_status);
   END IF;
END;
/
SELECT COUNT( * )
FROM sales
WHERE unit_price IS NULL;
/* Formatted on 2-Jan-2009 22:21:36 (QP5 v5.120.811.25008) */
