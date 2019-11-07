/* Formatted on 2008/10/12 13:00 (Formatter Plus v4.8.7) */
SPOOL notequals
SET echo on
SET lines 120
SET pages 10000
SET timing on

DROP TABLE customers_ne;
DROP TABLE customers_nl;
CREATE TABLE customers_nl AS SELECT * FROM sh.customers;

UPDATE customers_nl
   SET cust_valid = 'I'
 WHERE cust_valid = 'A';
UPDATE customers_nl
   SET cust_valid = 'A'
 WHERE MOD (cust_id, 1000) = 0;
UPDATE customers_nl
   SET cust_valid = NULL
 WHERE MOD (cust_id, 1000) = 1;
CREATE INDEX customers_nl_ix1 ON customers_nl(cust_valid);

SELECT   cust_valid, COUNT (*)
    FROM customers_nl
GROUP BY cust_valid;


BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_NL');
END;
/

SET autotrace on



SELECT MAX (cust_income_level), COUNT (*)
  FROM customers_nl c
 WHERE cust_valid IS NULL;

SELECT /*+ INDEX(c) */
       MAX (cust_income_level), COUNT (*)
  FROM customers_nl c
 WHERE cust_valid IS NULL;

ALTER TABLE customers_nl MODIFY cust_valid
DEFAULT 'U';

UPDATE customers_nl
   SET cust_valid  = 'U'
 WHERE cust_valid  IS NULL;
COMMIT ;


SELECT MAX (cust_income_level), COUNT (*)
  FROM customers_nl c
 WHERE cust_valid = 'U';


EXIT;

