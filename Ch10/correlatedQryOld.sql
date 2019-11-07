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

 



EXIT;
 
 SELECT employee_id, first_name, last_name, salary
  FROM employees a
 WHERE salary = (SELECT MAX (salary)
                   FROM employees b
                  WHERE b.department_id = a.department_id);
                  
SELECT  EMPLOYEE_ID . FIRST_NAME  ,
       LAST_NAME ,  SALARY 
  FROM (SELECT   MAX ( B . SALARY ) "MAX(SALARY)",
                  B.DEPARTMENT_ID  "ITEM_1"
            FROM  EMPLOYEES B 
        GROUP BY  B.DEPARTMENT_ID) "VW_SQ_2",
        EMPLOYEES 
 WHERE  A.SALARY" = "VW_SQ_2"."MAX(SALARY)"
   AND "VW_SQ_2"."ITEM_1" = A.DEPARTMENT_ID;
   
create index employee_dept_sal_i on employees(department_id,salary);  
 
/* Formatted on 2008/11/21 21:10 (Formatter Plus v4.8.7) */
SELECT employee_id, first_name, last_name
  FROM employees
 WHERE employee_id = (SELECT manager_id
                        FROM departments
                       WHERE department_id = employees.department_id);  
