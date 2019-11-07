spool parallel_insert
set echo on
set pages 1000
set lines 120
set serveroutput on
DROP TABLE sales;
CREATE TABLE sales AS
   SELECT   * FROM sh.sales;
CREATE TABLE sales_updates AS
   SELECT   * FROM sh.sales;
ROLLBACK;
ALTER SESSION ENABLE PARALLEL DML;

EXPLAIN PLAN FOR
 INSERT /*+ parallel(s) */
  INTO    sales s
SELECT   * FROM sales_updates;

SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

EXPLAIN PLAN FOR
 INSERT /*+ parallel(s) */
   INTO    sales s
 SELECT /*+ parallel(u) */ *
    FROM   sales_updates u;
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

EXPLAIN PLAN FOR
  INSERT /*+ parallel(s) noappend */
    INTO    sales s
  SELECT /*+ parallel(u) */ *
    FROM   sales_updates u;
    
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));
exit;
/* Formatted on 2-Jan-2009 12:14:51 (QP5 v5.120.811.25008) */
