/* Formatted on 2008/11/23 21:45 (Formatter Plus v4.8.7) */
SPOOL workeare
SET serveroutput on

ALTER SESSION SET tracefile_identifier=workarea;


SET lines 120
SET pages 10000
SET timing on
SET echo on

COLUMN "O/1/M" format a6
COLUMN sql_text format a60


SELECT   sql_id, child_number, operation_type, last_execution, active_time,
         sql_text
    FROM v$sql_workarea JOIN v$sql USING (sql_id, child_number)
   WHERE onepass_executions > 0
     AND sql_text LIKE '%FROM customers%'
     AND sql_text NOT LIKE '%v$sql%'
ORDER BY active_time DESC;

VAR sql_id varchar2(20);
VAR child_number number;
WITH sql_workarea AS
     (
        SELECT sql_id, child_number, operation_type, last_execution,
               active_time,
                  optimal_executions
               || '/'
               || onepass_executions
               || '/'
               || multipasses_executions "O/1/M",
               SUBSTR (sql_text, 1, 100) sql_text,
               RANK () OVER (ORDER BY active_time DESC) ranking
          FROM v$sql_workarea JOIN v$sql USING (sql_id, child_number)
               )
SELECT   *
    FROM sql_workarea
   WHERE ranking <= 5
ORDER BY rankingl
BEGIN
   SELECT sql_id, child_number
     INTO :sql_id, :child_number
     FROM v$sql
    WHERE sql_text LIKE
                       '%cust_last_name, cust_first_name, cust_year_of_birth%'
      AND sql_text NOT LIKE '%sql_id%'
      AND sql_text NOT LIKE 'explain%'
      AND UPPER (sql_text) NOT LIKE 'BEGIN%'
      AND ROWNUM = 1;
END;
/

SELECT operation_id, operation_type,
       ROUND (estimated_optimal_size / 1024) "est optimal KB",
       ROUND (estimated_onepass_size / 1024) "est 1pass KB",
       ROUND (last_memory_used / 1024) "Last Used KB",
          optimal_executions
       || '/'
       || onepass_executions
       || '/'
       || multipasses_executions "O/1/M"
  FROM v$sql_workarea JOIN v$sql USING (sql_id, child_number)
 WHERE sql_id = :sql_id AND child_number = :child_number;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (:sql_id, :child_number, 'MEMSTATS'));

EXIT;

