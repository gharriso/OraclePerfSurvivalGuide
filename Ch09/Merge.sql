/* Formatted on 2008/10/13 18:29 (Formatter Plus v4.8.7) */
SPOOL merge
SET timing on
SET echo on
SET lines 120
SET pages 1000

DROP TABLE customers_m;
CREATE TABLE customers_m AS SELECT * FROM sh.customers;
UPDATE customers_m
   SET cust_email = 'Sydney.Tang@company.com',
       cust_first_name = 'Sydney J'
 WHERE cust_id = 104496;

CREATE INDEX c_first_idx1 ON customers_m(cust_first_name);
CREATE INDEX c_last_idx1 ON customers_m(cust_last_name);
CREATE INDEX c_yob_idx1 ON customers_m(cust_year_of_birth);
CREATE INDEX c_concat_idx1 ON customers_m(cust_last_name,cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS_M');
END;
/

SET autotrace on

alter system flush buffer_cache; 

SELECT /*+ INDEX_COMBINE(c , C_LAST_IDX1  , C_FIRST_IDX1 , C_YOB_IDX1) */
       cust_id
  FROM customers_m c
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney J'
   AND cust_year_of_birth = 1947;

alter system flush buffer_cache; 

SELECT /*+ FULL(c) */
       cust_id
  FROM customers_m c
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney J'
   AND cust_year_of_birth = 1947;

alter system flush buffer_cache; 

SELECT /*+ INDEX(c, c_concat_idx1 ) */
       cust_id
  FROM customers_m c
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney J'
   AND cust_year_of_birth = 1947;
   
alter system flush buffer_cache; 

SELECT /*+ INDEX_COMBINE(c , C_LAST_IDX1  , C_FIRST_IDX1 , C_YOB_IDX1) */
       cust_id
  FROM customers_m c
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney J'
   AND cust_year_of_birth = 1947;   

DROP INDEX c_first_idx1;
DROP INDEX c_last_idx1;
DROP INDEX c_yob_idx1;
DROP INDEX c_concat_idx1;
CREATE BITMAP INDEX c_first_bi1 ON customers_m(cust_first_name);
CREATE BITMAP INDEX c_last_bi1 ON customers_m(cust_last_name);
CREATE BITMAP INDEX c_yob_bi1 ON customers_m(cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS_M');
END;
/
alter system flush buffer_cache; 

SELECT /*+ INDEX_COMBINE(c c_first_bi1 c_last_bi1 c_yob_bi1) */
       cust_id
  FROM customers_m c
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney J'
   AND cust_year_of_birth = 1947;

EXIT;

