DROP TABLE sales_np;
DROP TABLE sales_p;
CREATE TABLE sales_np AS
   SELECT   * FROM sh.sales;
CREATE TABLE sales_p
PARALLEL (DEGREE 2) AS
   SELECT   * FROM sh.sales;

SELECT   COUNT ( * ) FROM sales_np;

SELECT   COUNT ( * ) FROM sales_p;
/* Formatted on 30-Dec-2008 8:26:21 (QP5 v5.120.811.25008) */

SELECT  /*+ parallel(auto) */ COUNT ( * ) FROM sales_np;
