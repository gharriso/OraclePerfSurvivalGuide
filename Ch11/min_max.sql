/* Formatted on 2008/11/29 11:05 (Formatter Plus v4.8.7) */
SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL max_min

ALTER SESSION SET tracefile_identifier=max_min;
ALTER SESSION SET sql_trace=TRUE;

REM DROP TABLE sales;
CREATE TABLE sales AS SELECT * FROM sh.sales;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/

SET autotrace on

SELECT MAX (amount_sold)
  FROM sales;

SELECT MAX (amount_sold), MIN (amount_sold)
  FROM sales;

CREATE INDEX sales_amount_sold_i ON sales (amount_sold);

SELECT MAX (amount_sold)
  FROM sales;

SELECT MAX (amount_sold), MIN (amount_sold)
  FROM sales;

SELECT max_sold, min_sold
  FROM (SELECT MAX (amount_sold) max_sold
          FROM sales) maxt,
       (SELECT MIN (amount_sold) min_sold
          FROM sales) mint;

EXIT;

