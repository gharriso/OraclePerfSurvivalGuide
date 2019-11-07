/* Formatted on 2008/11/06 16:55 (Formatter Plus v4.8.7) */
SPOOL sm_vs_hash


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=sm_vs_hash;

DROP TABLE sales_summary;
DROP TABLE sales_details;
CREATE TABLE sales_summary AS SELECT * FROM sh.sales;
CREATE TABLE sales_details AS SELECT * FROM sh.sales WHERE time_id > SYSDATE-365;

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES_SUMMARY');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES_DETAILS');
END;
/

SELECT *
  FROM sales_summary JOIN sales_details
       USING (prod_id, cust_id, time_id, channel_id, promo_id)
       ;

SELECT   *
    FROM sales_summary JOIN sales_details
         USING (prod_id, cust_id, time_id, channel_id, promo_id)
ORDER BY prod_id, cust_id, time_id, channel_id, promo_id;

