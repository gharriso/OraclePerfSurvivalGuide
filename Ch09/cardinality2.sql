/* Formatted on 2008/10/13 20:42 (Formatter Plus v4.8.7) */
SPOOL range1


SET lines 120
SET pages 10000
SET echo on

alter session set tracefile_identifier=cardinality; 
alter session set sql_trace true; 


DROP TABLE customers_c;
CREATE TABLE customers_c AS SELECT * FROM sh.customers;
CREATE INDEX customers_c_ix1 ON customers_c(cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_C',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 1 '
                                 );
END;
/

VAR yob number

BEGIN
   :yob := 1913;
END;
/
SET autotrace on

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_c
 WHERE cust_year_of_birth =:yob;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_c
 WHERE cust_year_of_birth =1913;
 
select * from user_tab_col_statistics where table_name='CUSTOMERS_C' and column_name='CUST_YEAR_OF_BIRTH';








BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_C',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 100 '
                                 );
END;
/


SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_c
 WHERE cust_year_of_birth = :yob;
 
SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_c
 WHERE cust_year_of_birth =1913;
 
exit; 

 
