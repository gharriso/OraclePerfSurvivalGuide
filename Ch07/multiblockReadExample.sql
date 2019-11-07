/* Formatted on 2008/09/06 17:12 (Formatter Plus v4.8.7) */
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

SET autotrace on
SET echo on
SET pages 10000
SET lines 120

ALTER SESSION SET db_file_multiblock_read_count=16;

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

ALTER SESSION SET db_file_multiblock_read_count=1;

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

ALTER  SESSION SET db_file_multiblock_read_count=16;
ALTER   SESSION SET optimizer_index_caching=100;

SELECT MAX (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

