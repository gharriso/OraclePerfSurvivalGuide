spool trigger_overhead
set echo on
set pages 1000
set lines 120
set timing on
set serveroutput on
DROP TABLE sales;

CREATE TABLE sales AS
   SELECT *
   FROM sh.sales s
   WHERE ROWNUM < 1;

ALTER TABLE sales  ADD  unit_price number NOT NULL;

UPDATE sales
SET unit_price = amount_sold / quantity_sold;

TRUNCATE TABLE sales;
prompt no trigger
set autotrace on


INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD, UNIT_PRICE)
   SELECT /*+ cache(s) */
         PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD,
          AMOUNT_SOLD, amount_sold / quantity_sold
   FROM sh.sales s;
   
 

TRUNCATE TABLE sales;

CREATE TRIGGER SALES_IU_TRG
   BEFORE INSERT OR UPDATE
   ON SALES
   FOR EACH ROW
BEGIN
   :new.unit_price := :new.quantity_sold / :new.amount_sold;
END;
/

INSERT INTO SALES(PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD)
   SELECT /*+ cache(s) */
         PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD,
          AMOUNT_SOLD
   FROM sh.sales s;
   
 

COMMIT;
exit;
/* Formatted on 11-Jan-2009 14:49:25 (QP5 v5.120.811.25008) */
