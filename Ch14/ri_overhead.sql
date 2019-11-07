spool ri_overhead
set echo on
set pages 1000
set lines 120
set timing on
set serveroutput on
DROP TABLE sales;
DROP TABLE customers;

CREATE TABLE sales AS
   SELECT *
   FROM sh.sales s;

CREATE TABLE customers AS
   SELECT * FROM sh.customers;

ALTER TABLE customers ADD PRIMARY KEY (cust_id);
TRUNCATE TABLE sales;
prompt no ri
set autotrace on


INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
   SELECT /*+ cache(s) */
         PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD,
          AMOUNT_SOLD
   FROM sh.sales s;

TRUNCATE TABLE sales;
ALTER TABLE sales
    ADD CONSTRAINT fk1_sales FOREIGN KEY (cust_id)
       REFERENCES customers (cust_id);


INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
   SELECT /*+ cache(s) */
         PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD,
          AMOUNT_SOLD
   FROM sh.sales s;


COMMIT;
exit;
/* Formatted on 11-Jan-2009 14:50:25 (QP5 v5.120.811.25008) */
