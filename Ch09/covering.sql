/* Formatted on 2008/10/27 23:13 (Formatter Plus v4.8.7) */
SPOOL covering


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=or_qry;

ALTER SESSION SET sql_trace= TRUE;

ALTER SESSION SET optimizer_mode=first_rows;

DROP TABLE customers_c;
CREATE TABLE customers_c AS SELECT * FROM sh.customers;
CREATE INDEX customers_yob_idx ON customers_c ( cust_year_of_birth );

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_C',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 120'
                                 );
END;
/

SET autotrace on

SELECT MAX (cust_credit_limit)
  FROM customers_c
 WHERE cust_year_of_birth > 1989;

CREATE INDEX customers_yob_limit_idx ON customers_c 
    ( cust_year_of_birth,cust_credit_limit );

SELECT MAX (cust_credit_limit)
  FROM customers_c
 WHERE cust_year_of_birth > 1989;

EXIT;

