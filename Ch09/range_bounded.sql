/* Formatted on 2008/10/20 18:50 (Formatter Plus v4.8.7) */
SPOOL bounded


SET lines 120
SET pages 10000
SET echo on

ALTER SESSION SET tracefile_identifier=bounded;

ALTER SESSION SET sql_trace= TRUE;


DROP TABLE customers_r;
CREATE TABLE customers_r AS SELECT * FROM sh.customers;
CREATE INDEX customers_r_ix1 ON customers_r(cust_year_of_birth);

VAR yob1 number
VAR yob2 number

BEGIN
   :yob1 := 1985;
   :yob2 := 1988;
END;
/

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth BETWEEN :yob1 AND :yob2;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth BETWEEN 1985 AND 1988;

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
 WHERE cust_year_of_birth BETWEEN :yob1 AND :yob2;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth BETWEEN 1985 AND 1988;



BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_R',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 100 '
                                 );
END;
/

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth BETWEEN :yob1 AND :yob2;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_r
 WHERE cust_year_of_birth BETWEEN 1985 AND 1988;


SET autotrace off

SELECT num_distinct, UTL_RAW.cast_to_number (low_value) low_value,
       UTL_RAW.cast_to_number (high_value) high_value
  FROM all_tab_col_statistics
 WHERE table_name = 'CUSTOMERS_R' AND column_name = 'CUST_YEAR_OF_BIRTH';
 
 SELECT *
  FROM all_tab_statistics
 WHERE table_name = 'CUSTOMERS_R' ;

EXIT;

select count(*) from customers_r; 

