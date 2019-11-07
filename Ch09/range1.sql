/* Formatted on 2008/10/13 20:42 (Formatter Plus v4.8.7) */
SPOOL range1


SET lines 120
SET pages 10000
SET echo on

alter session set tracefile_identifier=range1; 
alter session set sql_trace true; 


DROP TABLE customers_r;
CREATE TABLE customers_r AS SELECT * FROM sh.customers;
CREATE INDEX customers_r_ix1 ON customers_r(cust_year_of_birth);

VAR yob number

BEGIN
   :yob := 1989;
END;
/

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > :yob;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > 1989;

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_R',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 1 '
                                 );
END;
/



SET autotrace on

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > :yob;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > 1989;
 
 SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth >= 1989;

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_R',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 100 '
                                 );
END;
/

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > :yob;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > 1989;

BEGIN
   :yob := 1989;
END;
/

BEGIN
   FOR i IN 1 .. 100
   LOOP
      FOR r IN (SELECT MAX (cust_credit_limit), COUNT (*)
                  FROM customers_r
                 WHERE cust_year_of_birth > :yob)
      LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
/

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth > :yob;
 
 
SELECT num_distinct, UTL_RAW.cast_to_number (low_value) low_value,
       UTL_RAW.cast_to_number (high_value) high_value
  FROM all_tab_col_statistics
 WHERE table_name = 'CUSTOMERS_R' AND column_name = 'CUST_YEAR_OF_BIRTH';
 
EXIT;

