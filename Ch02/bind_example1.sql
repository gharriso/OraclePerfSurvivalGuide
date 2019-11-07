set echo on 

VARIABLE bind_employee_number NUMBER

BEGIN
   :bind_employee_number := 206;
END;
/

SELECT first_name, last_name
  FROM hr.employees
 WHERE employee_id = :bind_employee_number
/

