/* Formatted on 2008/08/24 19:30 (Formatter Plus v4.8.7) */
DECLARE
   v_marketing_id   hr.departments.department_id%TYPE;
BEGIN
   SELECT department_id
     INTO v_marketing_id
     FROM hr.departments
    WHERE department_name = 'Marketing';

   FOR r IN (SELECT *
               FROM hr.employees)
   LOOP
      IF r.department_id = v_marketing_id
      THEN
         -- do something funky to the marketing guys here
         NULL;
      END IF;
   END LOOP;
END;

