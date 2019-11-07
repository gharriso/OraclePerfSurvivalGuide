/* Formatted on 2008/11/02 18:22 (Formatter Plus v4.8.7) */
SPOOL ffs


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=ffs;

ALTER SESSION SET sql_trace= TRUE;

DROP TABLE sales_ffs;

CREATE TABLE sales_ffs AS SELECT * FROM sh.sales;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES_FFS');
END;
/

SET autotrace on

alter system flush buffer_cache; 

SELECT   cust_id, SUM (amount_sold)
    FROM sales_ffs
GROUP BY cust_id
  HAVING SUM (amount_sold) > 350000
ORDER BY 2 DESC;
 
CREATE INDEX sales_ffs ON sales_ffs( cust_id,amount_sold);

alter system flush buffer_cache; 

SELECT   cust_id, SUM (amount_sold)
    FROM sales_ffs
GROUP BY cust_id
  HAVING SUM (amount_sold) > 350000
ORDER BY 2 DESC;

/


alter system flush buffer_cache; 
 
SELECT   /*+INDEX(s)*/
         cust_id, SUM (amount_sold)
    FROM sales_ffs s
GROUP BY cust_id
  HAVING SUM (amount_sold) > 350000
ORDER BY 2 DESC;
/

SELECT   /*+INDEX_FFS(s) INDEX_PARALLEL(s) */
         cust_id, SUM (amount_sold)
    FROM sales_ffs s
GROUP BY cust_id
  HAVING SUM (amount_sold) > 350000
ORDER BY 2 DESC;
/
 
EXIT;

