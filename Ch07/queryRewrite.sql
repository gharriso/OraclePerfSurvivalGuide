alter session set tracefile_identifier=query_rewrite;

alter session set events '10053 trace name context forever, level 1';
/* Formatted on 2008/09/03 21:50 (Formatter Plus v4.8.7) */
SELECT first_name, last_name
  FROM hr.employees
 WHERE department_id IN (SELECT department_id
                           FROM hr.departments
                          WHERE location_id IN (SELECT location_id
                                                  FROM hr.locations
                                                 WHERE city = 'Seattle'))

                                                 
/* Formatted on 2008/09/03 21:48 (Formatter Plus v4.8.7) */
SELECT          /*+ */
       DISTINCT "EMPLOYEES".ROWID "ROWID",
                "DEPARTMENTS"."DEPARTMENT_ID" "$nso_col_1",
                "EMPLOYEES"."FIRST_NAME" "FIRST_NAME",
                "EMPLOYEES"."LAST_NAME" "LAST_NAME"
           FROM "HR"."LOCATIONS" "LOCATIONS",
                "HR"."DEPARTMENTS" "DEPARTMENTS",
                "HR"."EMPLOYEES" "EMPLOYEES"
          WHERE "EMPLOYEES"."DEPARTMENT_ID" = "DEPARTMENTS"."DEPARTMENT_ID"
            AND "DEPARTMENTS"."LOCATION_ID" = "LOCATIONS"."LOCATION_ID"
            AND "LOCATIONS"."CITY" = 'Seattle';

