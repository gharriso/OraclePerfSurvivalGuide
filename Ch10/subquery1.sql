/* Formatted on 2008/11/17 16:12 (Formatter Plus v4.8.7) */
SPOOL subquery2
SET serveroutput on

ALTER SESSION SET tracefile_identifier=connectby;
ALTER SESSION SET sql_trace=TRUE;

SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE employees;

CREATE TABLE employees AS SELECT * FROM hr.employees;
UPDATE employees
   SET salary = 1000
 WHERE ROWNUM < 3;
COMMIT ;

set autotrace on 

SELECT COUNT (*)
  FROM employees
 WHERE salary = (SELECT MIN (salary)
                   FROM employees);

DECLARE
   last_salary   hr.employees.salary%TYPE;
   -- Keep track of previous salary
   counter       NUMBER                     := 0;
-- Count the number of rows
BEGIN
   FOR emp_row IN (SELECT   *
                       FROM employees
                   ORDER BY salary)
   LOOP
      --
      -- Exit the loop if the salary is greater
      -- than the previous salary
      --
      EXIT WHEN counter > 0 AND emp_row.salary > last_salary;
      -- Update the counter
      counter := counter + 1;
      -- save the salary
      last_salary := emp_row.salary;
   END LOOP;
   DBMS_OUTPUT.put_line (counter || ' employees have the minimum salary');
END;
/

WITH emp_salary AS
     (SELECT salary, MIN (salary) OVER () min_salary
        FROM employees)
SELECT SUM (DECODE (salary, min_salary, 1))
  FROM emp_salary;

