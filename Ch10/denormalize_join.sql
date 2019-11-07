/* Formatted on 2008/11/10 14:26 (Formatter Plus v4.8.7) */
DROP TABLE employees;

CREATE TABLE employees AS SELECT * FROM hr.employees;

ALTER TABLE employees ADD (department_name VARCHAR2(30));

CREATE OR REPLACE TRIGGER employees_dept_name_trg
   BEFORE INSERT OR UPDATE OF department_id
   ON employees
   FOR EACH ROW
BEGIN
   IF :NEW.department_id IS NOT NULL
   THEN
      SELECT department_name
        INTO :NEW.department_name
        FROM hr.departments
       WHERE department_id = :NEW.department_id;
   END IF;
END;
/
UPDATE employees
   SET department_id = department_id;

COMMIT ;

SELECT employee_id, first_name, last_name, department_name
  FROM hr.employees JOIN hr.departments USING (department_id)
       ;

SELECT employee_id, first_name, last_name, department_id, department_name
  FROM employees;

