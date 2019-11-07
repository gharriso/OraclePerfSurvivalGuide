/* Formatted on 2008/10/22 22:13 (Formatter Plus v4.8.7) */
SPOOL like


SET lines 120
SET pages 10000
SET echo on

ALTER SESSION SET tracefile_identifier=like_qry;

ALTER SESSION SET sql_trace= TRUE;

DROP TABLE customers_l;
CREATE TABLE customers_l AS SELECT * FROM sh.customers;
CREATE INDEX customers_l_ix1 ON customers_l(cust_last_name );

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS_L');
END;
/

SET autotrace on


SELECT MAX (cust_credit_limit),count(*)
  FROM customers_l
 WHERE cust_last_name LIKE 'Vaugh%';

SELECT MAX (cust_credit_limit),count(*) 
  FROM customers_l
 WHERE cust_last_name LIKE '%aughn';
 
 exit; 

