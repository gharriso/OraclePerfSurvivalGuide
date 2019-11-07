/* Formatted on 2008/09/06 10:37 (Formatter Plus v4.8.7) */
SPOOL histogramExample

SET pages 1000
SET lines 100

DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;
CREATE INDEX customers_country_ix ON customers(country_id);

BEGIN
   SYS.DBMS_STATS.gather_table_stats (ownname      => USER,
                                      tabname      => 'CUSTOMERS');
END;
/

SET echo on
SET autotrace on

SELECT density, num_nulls, num_distinct
  FROM user_tab_col_statistics
 WHERE table_name = 'CUSTOMERS' AND column_name = 'COUNTRY_ID';


SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52790;



SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52787;

SELECT *
  FROM TABLE (DBMS_XPLAN.display (NULL, NULL, 'BASIC', NULL));

BEGIN
   SYS.DBMS_STATS.gather_table_stats (ownname         => USER,
                                      tabname         => 'CUSTOMERS',
                                      method_opt      => 'FOR ALL INDEXED COLUMNS'
                                     );
END;
/

SELECT density, num_nulls, num_distinct
  FROM user_tab_col_statistics
 WHERE table_name = 'CUSTOMERS' AND column_name = 'COUNTRY_ID';



SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52790;


SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52787;

SELECT /*+ INDEX(customers) */
       MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52790;


SELECT /*+ INDEX(customers) */
       MAX (cust_income_level)
  FROM customers
 WHERE country_id = 52787;

ALTER SYSTEM FLUSH SHARED_POOL;

VARIABLE v_country_id number;

BEGIN
   :v_country_id := 52790;                                               --USA
END;
/

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

alter system flush shared_pool; 

VARIABLE v_country_id number;

BEGIN
   :v_country_id := 52785;                                      -- New Zealand
END;
/

SELECT /* +GH1 */ MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;


EXIT;

