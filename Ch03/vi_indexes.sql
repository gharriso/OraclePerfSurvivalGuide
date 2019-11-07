/* Formatted on 2008/07/31 14:05 (Formatter Plus v4.8.7) */
SET pagesize 10000;
SET echo on

DROP INDEX sh.sales_vi1;

EXPLAIN  PLAN FOR
    SELECT * FROM sh.sales WHERE quantity_sold > 10000
/
SELECT *
  FROM TABLE (DBMS_XPLAN.display (NULL, NULL, 'BASIC +COST'))
/
ALTER SESSION SET "_use_nosegment_indexes"=TRUE
/
CREATE INDEX sh.sales_vi1 ON sh.sales(quantity_sold )              NOSEGMENT
/
EXPLAIN  PLAN FOR
    SELECT * FROM sh.sales WHERE quantity_sold > 10000
/
SELECT *
  FROM TABLE (DBMS_XPLAN.display (NULL, NULL, 'BASIC +COST'))
/
DROP INDEX sh.sales_vi1;

