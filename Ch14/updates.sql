spool correlated_update
set echo on
set pages 1000
set lines 120
set serveroutput on
set timing on 

DROP TABLE sales;
DROP TABLE sales_updates;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

CREATE TABLE sales_updates AS
   SELECT prod_id, cust_id, time_id, channel_id, promo_id,
          quantity_sold * 2 quantity_sold, amount_sold * 2 amount_sold
   FROM sh.sales
   WHERE ROWNUM < 1000000;




ALTER TABLE sales ADD CONSTRAINT sales_pk PRIMARY KEY (prod_id,cust_id,time_id,channel_id,promo_id);
ALTER TABLE sales_updates ADD CONSTRAINT sales_updates_pk PRIMARY KEY (prod_id,cust_id,time_id,channel_id,promo_id);

COMMIT;

BEGIN
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'SALES');
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER,
   TABNAME => 'SALES_UPDATES');
END;
/


SELECT AVG(prod_id * cust_id * quantity_sold) FROM sales;

set autotrace on

UPDATE sales s
SET
    (amount_sold,
    quantity_sold
    ) =
       (SELECT amount_sold, quantity_sold
        FROM sales_updates u
        WHERE     u.prod_id = s.prod_id
              AND u.cust_id = s.cust_id
              AND u.time_id = s.time_id
              AND u.channel_id = s.channel_id)
WHERE EXISTS
         (SELECT 0
          FROM sales_updates u
          WHERE     u.prod_id = s.prod_id
                AND u.cust_id = s.cust_id
                AND u.time_id = s.time_id
                AND u.channel_id = s.channel_id);

SELECT AVG(prod_id * cust_id * quantity_sold) FROM sales;

ROLLBACK;

UPDATE (SELECT s.amount_sold, 
               s.quantity_sold,
               u.amount_sold new_amount_sold,
               u.quantity_sold new_quantity_sold
        FROM    sales s
             JOIN
                sales_updates u
             USING (prod_id, cust_id, time_id, 
                    channel_id, promo_id))
SET amount_sold = new_amount_sold, 
    quantity_sold = new_quantity_sold;

SELECT AVG(prod_id * cust_id * quantity_sold) FROM sales;

ROLLBACK;
/* Formatted on 15/01/2009 1:42:12 PM (QP5 v5.120.811.25008) */
