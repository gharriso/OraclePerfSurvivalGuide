/* Formatted on 2008/11/14 15:01 (Formatter Plus v4.8.7) */
SPOOL outerJoin


SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE employees;
DROP TABLE departments;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE departments AS SELECT * FROM hr.departments;
ALTER TABLE departments ADD constraint departments_pk PRIMARY KEY (department_id);
create index employees_dept_idx on employees(department_id); 

UPDATE departments
   SET department_id = 99
 WHERE department_id = 40;
COMMIT ;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'EMPLOYEES');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'DEPARTMENTS');
END;
/

SET autotrace on explain

SELECT /*+ ordered */
       first_name, last_name, department_name
  FROM employees LEFT OUTER JOIN departments USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+ ordered use_nl(d) */
       first_name, last_name, department_name
  FROM employees LEFT OUTER JOIN departments d USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+ ordered use_merge(d) */
       first_name, last_name, department_name
  FROM employees LEFT OUTER JOIN departments d USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+ ordered use_hash(d) */
       first_name, last_name, department_name
  FROM employees LEFT OUTER JOIN departments d USING (department_id)
 WHERE department_id IN (99, 40);


SELECT /*+ ordered */
       first_name, last_name, department_name
  FROM employees RIGHT OUTER JOIN departments 
                 USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+  use_hash(d) */
       first_name, last_name, department_name
  FROM employees FULL OUTER JOIN departments d 
       USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+  use_nl(d) */
       first_name, last_name, department_name
  FROM employees FULL OUTER JOIN departments d 
       USING (department_id)
 WHERE department_id IN (99, 40);

SELECT /*+  use_merge(d) */
       first_name, last_name, department_name
  FROM employees FULL OUTER JOIN departments d 
       USING (department_id)
 WHERE department_id IN (99, 40);

EXIT;

