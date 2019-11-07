/* Formatted on 2008/10/12 13:00 (Formatter Plus v4.8.7) */
SPOOL notequals
SET echo on
SET lines 120
SET pages 10000
SET timing on

 
DROP TABLE customers_nl;
CREATE TABLE customers_nl AS SELECT * FROM sh.customers;
alter table customers_nl add (process_flag varchar2(1)); 

UPDATE customers_nl
   SET process_flag  = NULL;
UPDATE customers_nl
   SET process_flag  = 'A'
 WHERE MOD (cust_id, 1000) = 0;

CREATE INDEX customers_nl_ix1 ON customers_nl(process_flag );

SELECT   process_flag , COUNT (*)
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
 WHERE process_flag  IS NOT NULL;

SELECT /*+ INDEX(c) */
       MAX (cust_income_level), COUNT (*)
  FROM customers_nl c
 WHERE process_flag  ='A'; 



EXIT;

