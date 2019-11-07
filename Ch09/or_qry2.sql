/* Formatted on 2008/10/27 22:02 (Formatter Plus v4.8.7) */
SPOOL or_query
SET timing on
SET echo on
SET lines 120
SET pages 1000

DROP TABLE customers_or;
CREATE TABLE customers_or AS SELECT * FROM sh.customers;

CREATE INDEX c_last_idx1 ON customers_or(cust_last_name);

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_OR');
END;

set autotrace on 

SELECT MAX (cust_credit_limit),count(*)
  FROM customers_or
 WHERE cust_last_name = 'Stock'
    OR cust_last_name = 'Stockman'
    OR cust_last_name = 'Stocks'
    OR cust_last_name = 'Stokley';

