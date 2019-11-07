/* Formatted on 2008/11/11 17:15 (Formatter Plus v4.8.7) */
SPOOL mv_join


SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE employees;
DROP TABLE departments;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE departments AS SELECT * FROM hr.departments;
ALTER SESSION SET sql_trace=TRUE;
ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';

ALTER SESSION SET tracefile_identifier=mv_join;

DROP MATERIALIZED VIEW cust_dept_mv;

CREATE MATERIALIZED VIEW  cust_dept_mv
REFRESH COMPLETE
ENABLE QUERY REWRITE
AS
SELECT e.employee_id, e.first_name, e.last_name,  department_id,
       d.department_name
  FROM  departments d JOIN  employees e USING (department_id);

ALTER SESSION SET query_rewrite_enabled=TRUE;
 

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'EMPLOYEES');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'DEPARTMENTS');
END;
/

SET autotrace on

SELECT e.employee_id, e.first_name, e.last_name, department_id,
       d.department_name
  FROM departments d JOIN employees e USING (department_id)
       ;
EXPLAIN PLAN FOR
SELECT e.employee_id, e.first_name, e.last_name, department_id,
       d.department_name
  FROM departments d JOIN employees e USING (department_id);

SELECT *
  FROM TABLE (DBMS_XPLAN.display ());

EXIT;

