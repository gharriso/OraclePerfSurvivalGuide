
SPOOL index_cluster

SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=index_cluster;

DROP TABLE orders;
DROP TABLE line_items;

 
 
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    order_date DATE,
    customer_id NUMBER
);


CREATE TABLE line_items (order_id NUMBER,
                         item_id NUMBER,
                         product_id NUMBER,
                         quantity NUMBER,
                         price NUMBER,
                         PRIMARY KEY (order_id,item_id));


 
INSERT INTO orders
            (order_id, order_date, customer_id)
   SELECT     ROWNUM pk, SYSDATE - DBMS_RANDOM.VALUE (0, 1000),
              ROUND (DBMS_RANDOM.VALUE (1, 2000)) /* no of customers */
         FROM DUAL
   CONNECT BY ROWNUM < 2000000  /* No of orders */ ; 
   
   
create index orders_cust_idx on orders(customer_id) ; 
 
/* Formatted on 2008/11/10 22:11 (Formatter Plus v4.8.7) */
INSERT INTO line_items
            (order_id, item_id, product_id, quantity, price)
   SELECT order_id, x.ID, ROUND (DBMS_RANDOM.VALUE (1, 200)),
          ROUND (DBMS_RANDOM.VALUE (1, 10)), round(dbms_random.value(1,300),2)
     FROM orders,
          (SELECT     ROWNUM ID
                 FROM DUAL
           CONNECT BY ROWNUM < 5) x;


DROP TABLE orders_clu;
DROP TABLE line_items_clu;

DROP CLUSTER orders_items_cluster;

CREATE CLUSTER orders_items_cluster (order_id NUMBER) SIZE 95;
CREATE INDEX orders_items_cluster_i1 ON CLUSTER orders_items_cluster;

CREATE TABLE orders_clu (
    order_id NUMBER PRIMARY KEY,
    order_date DATE,
    customer_id NUMBER
) cluster orders_items_cluster(order_id);


CREATE TABLE line_items_clu (order_id NUMBER,
                         item_id NUMBER,
                         product_id NUMBER,
                         quantity NUMBER,
                         price NUMBER,
                         PRIMARY KEY (order_id,item_id)) cluster orders_items_cluster(order_id);

insert into orders_clu SELECT * FROM orders;
create index orders_clu_cust_idx on orders_clu(customer_id) ; 

insert into line_items_clu SELECT * FROM line_items;
BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'orders');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'line_items');

   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'orders_clu');

   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'line_items_clu');

END;
/ 
 

set autotrace on 

alter system flush buffer_cache; 
 
SELECT /*+ USE_HASH(i) */ MIN (order_date), MAX (order_date),  SUM (price)
  FROM orders o  JOIN line_items  i USING (order_id)
 WHERE customer_id = 12;
 
alter system flush buffer_cache; 
 
SELECT /*+ USE_MERGE(i) */ MIN (order_date), MAX (order_date),  SUM (price)
  FROM orders o  JOIN line_items  i USING (order_id)
 WHERE customer_id = 12;
 

alter system flush buffer_cache; 
 
SELECT /*+ USE_NL(i) */  MIN (order_date), MAX (order_date),  SUM (price)
  FROM orders o  JOIN line_items  i USING (order_id)
 WHERE customer_id = 12;

alter system flush buffer_cache; 
 
SELECT MIN (order_date), MAX (order_date),  SUM (price)
  FROM orders_clu JOIN line_items_clu USING (order_id)
 WHERE customer_id = 12; 
 

       
       
exit; 



