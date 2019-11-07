connect &1
DROP TABLE sales;
DROP TABLE customers;
DROP TABLE products;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

CREATE TABLE sales_archive AS
   SELECT * FROM sales;

CREATE TABLE products AS
   SELECT * FROM sh.products;

CREATE TABLE customers AS
   SELECT * FROM sh.customers;

CREATE INDEX sales_i1
   ON sales(prod_id, cust_id);

CREATE INDEX sales_archiive_i1
   ON sales_archive(prod_id, cust_id);

CREATE INDEX products_i1
   ON products(prod_id);

CREATE INDEX customers_i1
   ON customers(cust_id);

BEGIN
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'SALES');
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER,
   TABNAME => 'SALES_ARCHIVE');
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'CUSTOMERS');
   sys.DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'PRODUCTS');
END;
/

ALTER SYSTEM FLUSH BUFFER_CACHE;


BEGIN
   dbms_result_cache.flush;
END;
/

alter system set result_cache_max_size=50m scope=memory;
connect &1

DECLARE
   t_cust_ids   DBMS_SQL.number_table;
   t_prod_ids   DBMS_SQL.number_table;
   v_prod_id    NUMBER;
   v_cust_id    NUMBER;
   v_time_id    DATE;
   CURSOR c1 IS
      SELECT /*+ RESULT_CACHE */
            SUM(amount_sold)
      FROM       sales_archive
              JOIN
                 products
              USING (prod_id)
           JOIN
              customers
           USING (cust_id)
      WHERE prod_id = v_prod_id AND cust_id = v_cust_id;
   CURSOR c2 IS
      SELECT /* noresult cache */
            SUM(amount_sold)
      FROM       sales_archive
              JOIN
                 products
              USING (prod_id)
           JOIN
              customers
           USING (cust_id)
      WHERE prod_id = v_prod_id AND cust_id = v_cust_id;

   CURSOR c3 IS
      SELECT /*+ RESULT_CACHE */
            PROD_NAME, SUM(AMOUNT_SOLD)
      FROM       SALES
              JOIN
                 PRODUCTS
              USING (PROD_ID)
           JOIN
              CUSTOMERS
           USING (CUST_ID)
      WHERE CUST_ID = v_cust_id AND TIME_ID > v_time_id
      GROUP BY PROD_NAME;
BEGIN
   SELECT SYSDATE - 100 INTO v_time_id FROM DUAL;

   SELECT cust_id
   BULK COLLECT
   INTO t_cust_ids
   FROM customers
   WHERE ROWNUM < 1001;

   SELECT prod_id
   BULK COLLECT
   INTO t_prod_ids
   FROM products
   WHERE ROWNUM < 100;

   FOR i IN 1 .. 12987 LOOP
      v_cust_id := t_cust_ids(ROUND(DBMS_RANDOM.VALUE(1, 200)));
      v_prod_id := t_prod_ids(ROUND(DBMS_RANDOM.VALUE(1, 10)));
      BEGIN
         FOR r IN c1 LOOP
            NULL;
         END LOOP;

         FOR r IN c2 LOOP
            NULL;
         END LOOP;

         IF DBMS_RANDOM.VALUE(0, 10) < 3 THEN
            FOR r IN c3 LOOP
               NULL;
            END LOOP;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
      END;
   END LOOP;
END;
/

@@sql_cache_stats
/* Formatted on 3/03/2009 11:57:12 AM (QP5 v5.120.811.25008) */
