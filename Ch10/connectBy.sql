/* Formatted on 2008/11/16 20:59 (Formatter Plus v4.8.7) */
SPOOL connectBy
ALTER SESSION SET tracefile_identifier=connectby;
ALTER SESSION SET sql_trace=TRUE;

SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE employees;

CREATE TABLE employees AS SELECT * FROM hr.employees;

ALTER TABLE employees ADD CONSTRAINT employees_pk PRIMARY KEY (employee_id);


BEGIN
   FOR i IN 1 .. 100
   LOOP
      INSERT INTO employees
                  (employee_id, first_name, last_name, email, phone_number,
                   hire_date, job_id, salary, commission_pct, manager_id,
                   department_id)
         SELECT employee_id + 1000 * i, first_name, last_name, email,
                phone_number, hire_date, job_id, salary, commission_pct,
                CASE
                   WHEN manager_id IS NULL
                      THEN 100
                   ELSE manager_id + 1000 * i
                END, department_id
           FROM hr.employees;
   END LOOP;

   COMMIT;
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'EMPLOYEES', method_opt=>'FOR ALL COLUMNS');
END;
/

SET autotrace on
EXPLAIN PLAN FOR
SELECT   LPAD ('-', LEVEL, '-') || employee_id, 
        first_name, last_name, manager_id
      FROM employees
CONNECT BY PRIOR employee_id = manager_id
START WITH employee_id = 100;

SELECT *
  FROM TABLE (DBMS_XPLAN.display ());

select count(*) from employees; 

CREATE INDEX employee_mgr_id ON employees(manager_id) COMPUTE STATISTICS;

EXPLAIN PLAN FOR
SELECT    LPAD ('-', LEVEL, '-') || employee_id, first_name, last_name,
           manager_id
      FROM employees e
CONNECT BY PRIOR employee_id = manager_id
START WITH employee_id = 100;
SELECT *
  FROM TABLE (DBMS_XPLAN.display ());

DROP INDEX employee_mgr_id;

WITH t1 AS
     (
        SELECT     LPAD ('-', LEVEL, '-') || employee_id, first_name,
                   last_name, manager_id
              FROM employees
        CONNECT BY PRIOR employee_id = manager_id
        START WITH employee_id = 100)
SELECT COUNT (*)
  FROM t1;

WITH t1 AS
     (
        SELECT     LPAD ('-', LEVEL, '-') || employee_id, first_name,
                   last_name, manager_id
              FROM employees
        CONNECT BY PRIOR employee_id = manager_id
        START WITH employee_id = 108)
SELECT COUNT (*)
  FROM t1;

CREATE INDEX employee_mgr_id ON employees(manager_id) COMPUTE STATISTICS;

WITH t1 AS
     (
        SELECT     LPAD ('-', LEVEL, '-') || employee_id, first_name,
                   last_name, manager_id
              FROM employees
        CONNECT BY PRIOR employee_id = manager_id
        START WITH employee_id = 100)
SELECT COUNT (*)
  FROM t1;

WITH t1 AS
     (
        SELECT     LPAD ('-', LEVEL, '-') || employee_id, first_name,
                   last_name, manager_id
              FROM employees
        CONNECT BY PRIOR employee_id = manager_id
        START WITH employee_id = 108)
SELECT COUNT (*)
  FROM t1;



EXIT;

