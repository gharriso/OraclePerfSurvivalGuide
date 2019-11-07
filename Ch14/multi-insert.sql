spool multi_table
set pagesize 1000
set lines 100
set echo on
set timing on
DROP TABLE sales_US;
DROP TABLE sales_emea;
DROP TABLE sales_updates;

CREATE TABLE sales_us AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

CREATE TABLE sales_emea AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;


CREATE TABLE sales_updates AS
   SELECT CASE MOD(prod_id, 3) WHEN 0 THEN 'EMEA' ELSE 'US' END region,
          prod_id, cust_id, time_id, channel_id, promo_id,
          quantity_sold * 2 quantity_sold, amount_sold * 2 amount_sold
   FROM sh.sales
   WHERE ROWNUM < 1000000;
/* Formatted on 17/01/2009 1:43:24 PM (QP5 v5.120.811.25008) */

COMMIT;
ALTER SYSTEM FLUSH BUFFER_CACHE;
set autotrace on 

INSERT ALL
  WHEN region = 'EMEA' THEN INTO sales_emea
           (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
            QUANTITY_SOLD, AMOUNT_SOLD)
    VALUES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, 
            QUANTITY_SOLD, AMOUNT_SOLD)
  WHEN region = 'US' THEN INTO sales_us 
           (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID,
            QUANTITY_SOLD, AMOUNT_SOLD)
    VALUES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, 
            QUANTITY_SOLD, AMOUNT_SOLD)
SELECT * FROM sales_updates;
 

DROP TABLE sales_US;
DROP TABLE sales_emea;
DROP TABLE sales_updates;

CREATE TABLE sales_us AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

CREATE TABLE sales_emea AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;


CREATE TABLE sales_updates AS
   SELECT CASE MOD(prod_id, 3) WHEN 0 THEN 'EMEA' ELSE 'US' END region,
          prod_id, cust_id, time_id, channel_id, promo_id,
          quantity_sold * 2 quantity_sold, amount_sold * 2 amount_sold
   FROM sh.sales
   WHERE ROWNUM < 1000000;
ALTER SYSTEM FLUSH BUFFER_CACHE;

INSERT INTO sales_emea
         (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, 
          PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
   SELECT PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, 
          PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD
   FROM sales_updates
   WHERE region = 'EMEA';
   
ALTER SYSTEM FLUSH BUFFER_CACHE;

INSERT INTO sales_us
         (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, 
          PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
   SELECT PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, 
          PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD
   FROM sales_updates
   WHERE region = 'US';

exit; 
