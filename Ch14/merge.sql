spool merge
set echo on
set pages 1000
set lines 120
set serveroutput on
DROP TABLE sales;
DROP TABLE sales_updates;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

CREATE TABLE sales_updates AS
   SELECT prod_id,cust_id,time_id,channel_id,promo_id, quantity_sold*2 quantity_sold,  amount_sold*2 amount_sold
   FROM sh.sales where rownum <10000; 
 

INSERT INTO sales_updates
   SELECT  prod_id, cust_id,  time_id + 10000,  channel_id,  promo_id,
          quantity_sold,  amount_sold
   FROM sales_updates; 
 

ALTER TABLE sales ADD CONSTRAINT sales_pk PRIMARY KEY (prod_id,cust_id,time_id,channel_id,promo_id);
ALTER TABLE sales_updates ADD CONSTRAINT sales_updates_pk PRIMARY KEY (prod_id,cust_id,time_id,channel_id,promo_id);
/* Formatted on 13/01/2009 9:48:54 PM (QP5 v5.120.811.25008) */

COMMIT;

BEGIN
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'SALES');
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER,
   TABNAME => 'SALES_UPDATES');
END;
/

EXPLAIN PLAN FOR
MERGE /*+ index(s) */ INTO sales s USING sales_updates u
   ON (s.prod_id=u.prod_id AND s.cust_id=u.cust_id AND s.time_id=u.time_id
       AND s.channel_id=u.channel_id AND s.promo_id = u.promo_id)
  WHEN MATCHED THEN
UPDATE SET    s.amount_sold  =u.amount_sold,
            s.quantity_sold=u.quantity_sold
WHEN NOT MATCHED THEN
INSERT VALUES ( u.prod_id, u.cust_id, u.time_id  ,
                u.channel_id, u.promo_id,
                u.quantity_sold, u.amount_sold);

SELECT * FROM table(DBMS_XPLAN.display());

set autotrace on
set timing on

alter system flush buffer_cache; 

MERGE /*+   full(s) */ INTO sales s USING sales_updates u
   ON (s.prod_id=u.prod_id AND s.cust_id=u.cust_id AND s.time_id=u.time_id
       AND s.channel_id=u.channel_id AND s.promo_id = u.promo_id)
  WHEN MATCHED THEN
UPDATE SET    s.amount_sold  =u.amount_sold,
            s.quantity_sold=u.quantity_sold
WHEN NOT MATCHED THEN
INSERT VALUES ( u.prod_id, u.cust_id, u.time_id  ,
                u.channel_id, u.promo_id,
                u.quantity_sold, u.amount_sold);
              

ROLLBACK;



SELECT avg(prod_id * cust_id * quantity_sold) FROM sales; 

alter system flush buffer_cache; 

MERGE /*+   index(s) */ INTO sales s USING sales_updates u
   ON (s.prod_id=u.prod_id AND s.cust_id=u.cust_id AND s.time_id=u.time_id
       AND s.channel_id=u.channel_id AND s.promo_id = u.promo_id)
  WHEN MATCHED THEN
UPDATE SET    s.amount_sold  =u.amount_sold,
            s.quantity_sold=u.quantity_sold
WHEN NOT MATCHED THEN
INSERT VALUES ( u.prod_id, u.cust_id, u.time_id  ,
                u.channel_id, u.promo_id,
                u.quantity_sold, u.amount_sold);
       
SELECT avg(prod_id * cust_id * quantity_sold) FROM sales;

ROLLBACK;

alter system flush buffer_cache; 

UPDATE (SELECT s.amount_sold, s.quantity_sold,
               u.amount_sold new_amount_sold,
               u.quantity_sold new_quantity_sold
        FROM   sales s
             JOIN sales_updates u
             USING (prod_id, cust_id, time_id, channel_id, promo_id))  
   SET amount_sold = new_amount_sold, 
       quantity_sold = new_quantity_sold;

INSERT INTO sales s
   SELECT *
   FROM sales_updates u
   WHERE NOT EXISTS
            (SELECT 0
             FROM sales s
             WHERE     s.prod_id = u.prod_id
                   AND s.cust_id = u.cust_id
                   AND s.time_id = u.time_id
                   AND s.channel_id = u.channel_id
                   AND s.promo_id = u.promo_id);
                   

 
SELECT avg(prod_id * cust_id * quantity_sold) FROM sales;
 
ROLLBACK; 



exit;

/* Formatted on 13/01/2009 6:09:48 PM (QP5 v5.120.811.25008) */
