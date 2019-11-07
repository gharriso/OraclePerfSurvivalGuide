/* Formatted on 2008/11/06 16:55 (Formatter Plus v4.8.7) */
SPOOL sm_vs_hash


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=sm_vs_hash;

DROP TABLE sales_summary;
DROP TABLE sales_details;
CREATE TABLE sales_summary AS SELECT *  FROM sh.sales sample   (1.5);  
CREATE TABLE sales_details AS SELECT * FROM sh.sales sample   (1.5);
select count(*) from sales_summary; 
BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES_SUMMARY');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES_DETAILS');
END;
/

set autotrace on 
alter system flush buffer_cache; 

SELECT /*+ ORDERED USE_NL(d)  ) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;

create index sales_sum_prod_idx on sales_details(prod_id); 

alter system flush buffer_cache; 

SELECT /*+ ORDERED USE_NL(d) INDEX(d)  */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;
       
drop index sales_sum_prod_idx;  
create index sales_sum_time_idx on sales_details(time_id); 

alter system flush buffer_cache; 

SELECT /*+ ORDERED USE_NL(d) INDEX(d) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;
       
drop index sales_sum_time_idx;         
create index sales_summary_i2 on sales_details(prod_id,channel_id); 

alter system flush buffer_cache;

SELECT /*+ ORDERED USE_NL(d) INDEX(d) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;
       
create index sales_summary_i3 on sales_details(prod_id,channel_id,cust_id);  

alter system flush buffer_cache;

SELECT /*+ ORDERED USE_NL(d) INDEX(d) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;
       
create index sales_summary_i4 on sales_details(prod_id,channel_id,cust_id,time_id);  
alter system flush buffer_cache;

SELECT /*+ ORDERED USE_NL(d) INDEX(d) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;
       
create index sales_summary_i5 on sales_details(prod_id,channel_id,cust_id,time_id,promo_id);  
alter system flush buffer_cache;

SELECT /*+ ORDERED USE_NL(d) INDEX(d) */ sum(s.quantity_sold),sum(d.amount_sold)
  FROM sales_summary s JOIN sales_details d
       USING (prod_id, cust_id, time_id, channel_id, promo_id) ;

exit; 
       
       
       
