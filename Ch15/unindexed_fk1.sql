DROP TABLE employees;
DROP TABLE departments;

CREATE TABLE employees AS
   SELECT * FROM hr.employees;

CREATE TABLE departments AS
   SELECT * FROM hr.departments;

ALTER TABLE departments ADD CONSTRAINT dept_pk PRIMARY KEY (department_id);
ALTER TABLE employees
ADD CONSTRAINT emp_dept_fk
FOREIGN KEY (department_id)
REFERENCES departments (department_id);

commit; 
set lines 100
set pages 1000
column type format a4
column name format a20
column lock_mode format a20
column table_name format a15

set echo on 

delete from departments where  department_id=10; 

select type, name, lock_mode, table_name  from v_my_locks; 

/* Formatted on 25/01/2009 10:01:48 PM (QP5 v5.120.811.25008) */
