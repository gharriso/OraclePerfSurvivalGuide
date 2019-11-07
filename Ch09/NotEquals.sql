/* Formatted on 2008/10/12 12:43 (Formatter Plus v4.8.7) */
SPOOL notequals
SET echo on
SET lines 120
SET pages 10000
set timing on 

rem DROP TABLE customers_ne;
CREATE TABLE customers_ne AS SELECT * FROM sh.customers;

UPDATE customers_ne
   SET cust_valid = 'I'
 WHERE cust_valid = 'A';
UPDATE customers_ne
   SET cust_valid = 'A'
 WHERE MOD (cust_id, 1000) = 0;
CREATE INDEX customers_ne_ix1 ON customers_ne(cust_valid);

SELECT   cust_valid, COUNT (*)
    FROM customers_ne
GROUP BY cust_valid;


BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_NE');
END;
/

SET autotrace on

alter system flush buffer_cache; 

SELECT MAX (cust_income_level), COUNT (*)
  FROM customers_ne c
 WHERE cust_valid = 'A';

alter system flush buffer_cache; 

SELECT MAX (cust_income_level), COUNT (*)
  FROM customers_ne c
 WHERE cust_valid <> 'I';
 
alter system flush buffer_cache; 
 
SELECT /*+ INDEX(c) */ MAX (cust_income_level), COUNT (*)
  FROM customers_ne c 
 WHERE cust_valid <> 'I'; 

EXIT;

