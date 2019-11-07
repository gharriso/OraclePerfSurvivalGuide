spool parallel_insert
set echo on
set pages 1000
set lines 120
set serveroutput on
DROP TABLE sales;
DROP TABLE sales_updates;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

CREATE TABLE sales_updates AS
   SELECT *
   FROM sh.sales
   WHERE MOD(ROWNUM, 5) = 0;

INSERT INTO sales_updates
   SELECT a.prod_id, a.cust_id, a.time_id + 400, a.channel_id, a.promo_id,
          a.quantity_sold, a.amount_sold
   FROM sales a
   WHERE time_id > SYSDATE - 400;


COMMIT;
ALTER SESSION ENABLE PARALLEL DML;
EXPLAIN PLAN FOR
MERGE INTO sales s USING sales_updates u
   ON (s.prod_id=u.prod_id AND s.cust_id=u.cust_id AND s.time_id=u.time_id
       AND s.channel_id=u.channel_id AND s.promo_id = u.promo_id)
  WHEN MATCHED THEN
UPDATE SET    s.amount_sold  =u.amount_sold,
            s.quantity_sold=u.quantity_sold
WHEN NOT MATCHED THEN
INSERT VALUES ( u.prod_id, u.cust_id, u.time_id  ,
                u.channel_id, u.promo_id,
                u.quantity_sold, u.amount_sold);

SELECT * FROM table(DBMS_XPLAN.display(NULL, NULL, 'BASIC +PARALLEL'));
EXPLAIN PLAN FOR
MERGE /*+ parallel(s) parallel(u)  */ INTO sales s USING sales_updates u
   ON (s.prod_id=u.prod_id AND s.cust_id=u.cust_id AND s.time_id=u.time_id
       AND s.channel_id=u.channel_id AND s.promo_id = u.promo_id)
  WHEN MATCHED THEN
UPDATE SET  s.amount_sold  =u.amount_sold,
            s.quantity_sold=u.quantity_sold
WHEN NOT MATCHED THEN
INSERT VALUES ( u.prod_id, u.cust_id, u.time_id  ,
                u.channel_id, u.promo_id,
                u.quantity_sold, u.amount_sold);

SELECT * FROM table(DBMS_XPLAN.display(NULL, NULL, 'BASIC +PARALLEL'));


ROLLBACK;
/* Formatted on 11/01/2009 10:03:16 PM (QP5 v5.120.811.25008) */
