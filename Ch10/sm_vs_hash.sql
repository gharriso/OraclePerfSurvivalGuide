/* Formatted on 2008/11/05 17:25 (Formatter Plus v4.8.7) */
SPOOL sm_vs_hash


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=sm_vs_hash;

CREATE TABLE sales_summary AS SELECT * FROM sh.sales;
CREATE TABLE sales_details AS SELECT * FROM sh.sales where time_id > sysdate-365 ;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES_SUMMARY');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES_DETAILS');
END;
/

select * from sales_summary join sales_details 
 using (prod_id,cust_id,time_id,channel_id,promo_id) ; 

select * from sales_summary join sales_details 
 using (prod_id,cust_id,time_id,channel_id,promo_id)
 order by prod_id,cust_id,time_id,channel_id,promo_id ;
