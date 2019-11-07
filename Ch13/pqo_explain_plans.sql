SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL pqo_explain
set arraysize 100
ALTER SESSION SET tracefile_identifier=pqo_explain;
ALTER SESSION SET sql_trace=TRUE;
DROP TABLE sales;
DROP TABLE products;

CREATE TABLE sales AS
   SELECT   * FROM sh.sales;

CREATE TABLE products AS
   SELECT   * FROM sh.products;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'PRODUCTS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/

EXPLAIN PLAN
   FOR

      SELECT /*+  parallel(s,2)   */
             *
        FROM   sales s;

SELECT   * FROM table (DBMS_XPLAN.display ());

EXPLAIN PLAN
   FOR

        SELECT /*+  parallel(s,2)   */
               *
          FROM   sales
      ORDER BY   1, 2, 3;

SELECT   * FROM table (DBMS_XPLAN.display ());

EXPLAIN PLAN
   FOR

      SELECT /*+ ordered parallel(s,2)  parallel(p,2) */
            prod_name, time_id, quantity_sold
        FROM      sales s
               JOIN
                  products p
               USING (prod_id);

SELECT   * FROM table (DBMS_XPLAN.display ());



EXPLAIN PLAN
   FOR

        SELECT /*+ ordered parallel(s,2)  parallel(p,2) */
              prod_name, time_id, quantity_sold
          FROM      sales s
                 JOIN
                    products p
                 USING (prod_id)
      ORDER BY   prod_name, time_id;

SELECT   * FROM table (DBMS_XPLAN.display ());

EXPLAIN PLAN
   FOR

        SELECT /*+ ordered parallel(s,2)  parallel(p,2) */
              prod_name, time_id, SUM (quantity_sold)
          FROM      sales s
                 JOIN
                    products p
                 USING (prod_id)
      GROUP BY   prod_name, time_id
      ORDER BY   prod_name, time_id;


SELECT   * FROM table (DBMS_XPLAN.display ());

DROP TABLE sales_archive;

CREATE TABLE sales_archive AS
   SELECT   *
     FROM   sh.sales
    WHERE   ROWNUM < 1;

EXPLAIN PLAN
   FOR

      INSERT /*+parallel (sa,4) append */
            INTO sales_archive sa
         SELECT /*+parallel (s,4) */
                *  FROM sh.sales;

SELECT   * FROM table (DBMS_XPLAN.display ());

  SELECT   DISTINCT operation, options, other_tag
    FROM   plan_table
ORDER BY   operation, options;
/* Formatted on 23-Dec-2008 21:58:35 (QP5 v5.120.811.25008) */
