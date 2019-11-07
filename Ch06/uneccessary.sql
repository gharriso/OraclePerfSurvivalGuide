/* Formatted on 2008/08/24 19:24 (Formatter Plus v4.8.7) */
DECLARE
   v_department_name   hr.departments.department_name%TYPE;
BEGIN
   FOR r IN (SELECT *
               FROM hr.employees)
   LOOP
      SELECT department_name
        INTO v_department_name
        FROM hr.departments
       WHERE department_id = r.department_id;

      IF v_department_name = 'MARKETING'
      THEN
         -- do something funky to the marketing guys here
         NULL;
      END IF;
   END LOOP;
END;

