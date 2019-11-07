/* Formatted on 2008/10/22 22:25 (Formatter Plus v4.8.7) */
SPOOL like


SET lines 120
SET pages 10000
SET echo on

ALTER SESSION SET tracefile_identifier=or_qry;

ALTER SESSION SET sql_trace= TRUE;

DROP TABLE customers_o;
CREATE TABLE customers_o AS SELECT * FROM sh.customers;
CREATE INDEX customers_o_ix1 ON customers_o (cust_last_name );

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS_O', method_opt=>'FOR ALL COLUMNS SIZE 1');
END;
/

SET autotrace on

REM select  cust_last_name,count(*) from  customers_o group by  cust_last_name  order by 2 desc;

SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_o
 WHERE cust_last_name IN ('Baker', 'Bakerman', 
                  'Bakker', 'Backer', 'Bacer');

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS_O' );
END;
/
SELECT MAX (cust_credit_limit), COUNT (*)
  FROM customers_o
 WHERE cust_last_name IN ('Baker', 'Bakerman', 
                  'Bakker', 'Backer', 'Bacer');
/

EXIT;

