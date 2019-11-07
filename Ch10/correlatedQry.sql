/* Formatted on 2008/11/21 20:52 (Formatter Plus v4.8.7) */
SPOOL correlated
SET serveroutput on

ALTER SESSION SET tracefile_identifier=correlated;
ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';


SET lines 120
SET pages 10000
SET timing on
SET echo on

SET autotrace on
DROP TABLE employees;
drop table departments; 

CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE departments AS SELECT * FROM hr.departments;

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'EMPLOYEES'
                                 );
      DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'DEPARTMENTS'
                                 );


END;
/

 
/* Formatted on 2008/11/21 21:10 (Formatter Plus v4.8.7) */
SELECT employee_id, first_name, last_name
  FROM employees
 WHERE employee_id = (SELECT manager_id
                        FROM departments
                       WHERE department_id = employees.department_id);



 
 SELECT employee_id, first_name, last_name, salary
  FROM employees a
 WHERE salary = (SELECT MIN (salary)
                   FROM employees b
                  WHERE b.department_id = a.department_id);
                  
SELECT   a.employee_id employee_id, a.first_name first_name,
         a.last_name last_name, a.salary salary
  FROM   (  SELECT   MIN (b.salary) "MIN(SALARY)", 
                     b.department_id item_1
              FROM   opsg.employees b
          GROUP BY   b.department_id) vw_sq_2, opsg.employees a
 WHERE   a.salary = vw_sq_2."MIN(SALARY)" 
   AND vw_sq_2.item_1 = a.department_id; 

   
WITH employees_w AS 
    (SELECT e.*, 
            MIN(salary) OVER (PARTITION BY department_id) dept_min_sal
     FROM employees e)
SELECT employee_id, first_name, last_name, salary
  FROM employees_w 
 WHERE salary=dept_min_sal;   
   
create index employee_dept_sal_i on employees(department_id,salary);  
   
