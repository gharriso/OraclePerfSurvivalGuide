spool materialize 

DROP TABLE departments;
DROP TABLE employees;

CREATE TABLE departments 
AS
   SELECT   * FROM hr.departments;

CREATE TABLE employees
AS
   SELECT   * FROM hr.employees;

select department_name,count(*) from departments join employees using (department_id) group by department_name  ; 

with sales_employees as 
 (select * from employees where department_id=(select department_id from departments where department_name='Sales'))
select * from sales_employees e join sales_employees m 
 on ( m.employee_id=e.manager_id)
