alter system flush shared_pool; 
alter session set tracefile_identifier=peeks;
alter session set sql_trace true; 

set autotrace on 

VARIABLE v_country_id number;

BEGIN
   :v_country_id := 52787;                                      -- New Zealand
END;
/

SELECT /* +GH1 */ MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;


EXIT;
