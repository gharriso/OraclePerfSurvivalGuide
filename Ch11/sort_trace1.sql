alter session set tracefile_identifier=e10033;
alter session set workarea_size_policy = manual;
alter session set sort_area_size = 1048576;
alter session set sql_trace=true; 


ALTER SESSION SET EVENTS '10032 trace name context forever, level 1';
/* Formatted on 9-Dec-2008 15:59:01 (QP5 v5.120.811.25008) */
alter session set events '10033 trace name context forever, level 1' ; 

DECLARE  /* gh1 minus  */
   CURSOR c1
   IS
      SELECT                                            
             ' gh1 minus' t,cust_first_name  cust_first_name, cust_last_name,
             cust_year_of_birth
        FROM microsoft_customers gh1 
      MINUS
      SELECT '  gh1 minus' t,cust_first_name cust_first_name, cust_last_name,
             cust_year_of_birth
        FROM google_customers;

   r1   c1%ROWTYPE;
BEGIN
   FOR r1 IN c1
   LOOP
      NULL;
   END LOOP;
END;
/

exit; 
