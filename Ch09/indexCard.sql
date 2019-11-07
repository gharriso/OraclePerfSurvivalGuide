/* Formatted on 2008/10/12 11:15 (Formatter Plus v4.8.7) */
SPOOL cardinality1

SET lines 120
SET pages 10000
SET echo on


DROP TABLE customers_ct;
CREATE TABLE customers_ct AS SELECT * FROM sh.customers;
CREATE INDEX customers_ct_ix1 ON customers_ct(cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_CT',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 1 '
                                 );
END;
/

SELECT num_distinct, UTL_RAW.cast_to_number (low_value),
       UTL_RAW.cast_to_number (high_value),
         (1960 - UTL_RAW.cast_to_number (low_value))
       / (  UTL_RAW.cast_to_number (high_value)
          - UTL_RAW.cast_to_number (low_value)
         ),
         55000
       -   55000
         * (1960 - UTL_RAW.cast_to_number (low_value))
         / (  UTL_RAW.cast_to_number (high_value)
            - UTL_RAW.cast_to_number (low_value)
           )
  FROM all_tab_col_statistics
 WHERE table_name = 'CUSTOMERS_CT' AND column_name = 'CUST_YEAR_OF_BIRTH';

column low_value format 9999999999
column high_value format 9999999999

SELECT num_distinct, UTL_RAW.cast_to_number (low_value) low_value,
       UTL_RAW.cast_to_number (high_value) high_value 
  FROM all_tab_col_statistics
 WHERE table_name = 'CUSTOMERS_CT' AND column_name = 'CUST_YEAR_OF_BIRTH';

SET autotrace on

SELECT COUNT (*)
  FROM customers_ct
 WHERE cust_year_of_birth < 1918;

SELECT COUNT (*)
  FROM customers_ct
 WHERE cust_year_of_birth < 1932;
 
SELECT COUNT (*)
  FROM customers_ct
 WHERE cust_year_of_birth < 1951;  

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_CT',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 100 '
                                 );
END;
/

SELECT COUNT (*)
  FROM customers_ct
 WHERE cust_year_of_birth < 1932;


EXIT;

