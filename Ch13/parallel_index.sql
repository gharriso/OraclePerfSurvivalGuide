spool parallel_index
set echo on
set pages 1000
set lines 120
set timing on
set serveroutput on
set autotrace on
DROP TABLE sales;
CREATE TABLE sales
PARTITION BY HASH (time_id)(PARTITION p1, PARTITION p2, PARTITION p3)
 AS
   SELECT * FROM sh.sales;
CREATE INDEX sales_i1
   ON sales(cust_id)
   LOCAL;
ALTER SYSTEM FLUSH BUFFER_CACHE;

SELECT /*+ parallel_index(s) index(s)  */
       *
FROM sales s
WHERE cust_id = 247;

EXPLAIN PLAN
   FOR
      SELECT /*+ parallel_index(s) index(s)  */
             *
      FROM sales s
      WHERE cust_id = 247;
SELECT * FROM table(DBMS_XPLAN.display(NULL, NULL, 'BASIC +PARALLEL'));
/* Formatted on 10/01/2009 3:03:13 PM (QP5 v5.120.811.25008) */

SELECT * FROM v$pq_tqstat;
DROP TABLE sales;
CREATE TABLE sales
PARTITION BY HASH (time_id)(PARTITION p1, PARTITION p2, PARTITION p3)
 AS
   SELECT * FROM sh.sales;
create index sales_i1 on sales ( cust_id) global;
ALTER SYSTEM FLUSH BUFFER_CACHE;

SELECT /*+ parallel_index(s) index(s)  */
       *
FROM sales s
WHERE cust_id = 247;

SELECT * FROM v$pq_tqstat;
/* Formatted on 10/01/2009 3:00:55 PM (QP5 v5.120.811.25008) */
