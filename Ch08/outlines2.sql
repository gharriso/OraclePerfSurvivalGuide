/* Formatted on 2008/09/10 17:20 (Formatter Plus v4.8.7) */
/* Demo of stabalizing a plan with an outline */

SPOOL outlines2
DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;

CREATE INDEX cust_year_of_birth_idx ON customers(cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS',
                                  method_opt      => 'FOR ALL INDEXED COLUMNS'
                                 );
END;
/

SELECT *
  FROM user_tab_col_statistics
 WHERE table_name = 'CUSTOMERS' AND column_name = 'CUST_YEAR_OF_BIRTH';


SET pages 10000
SET lines 120

SET autotrace on
SET echo on

ALTER SESSION SET db_file_multiblock_read_count=16;

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

ALTER SESSION SET db_file_multiblock_read_count=1;

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

SET autotrace off

ALTER SESSION SET db_file_multiblock_read_count=16;

drop outline customer_yob_qry;

CREATE OUTLINE customer_yob_qry FOR CATEGORY outlines2 ON
SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

SELECT NAME, CATEGORY, sql_text
  FROM user_outlines;
SELECT *
  FROM user_outline_hints
 WHERE NAME = 'CUSTOMER_YOB_QRY';

ALTER SESSION SET use_stored_outlines=outlines2; 

ALTER SESSION SET db_file_multiblock_read_count=1;

SET autotrace on

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

EXIT;

