/* Formatted on 2008/11/29 10:52 (Formatter Plus v4.8.7) */
SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL aggregate1

ALTER SESSION SET tracefile_identifier=aggregate1;
ALTER SESSION SET sql_trace=TRUE;

REM DROP TABLE sales;
CREATE TABLE sales AS SELECT * FROM sh.sales;

SET autotrace on
SELECT SUM (quantity_sold)
  FROM sales;

CREATE INDEX sales_quant_sold_i1 ON sales ( quantity_sold);

SELECT SUM (quantity_sold)
  FROM sales;

EXIT;

