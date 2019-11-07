connect &1
DROP TABLE sales;
DROP TABLE customers;
DROP TABLE products;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

CREATE TABLE products AS
   SELECT * FROM sh.products;

CREATE TABLE customers AS
   SELECT * FROM sh.customers;

ALTER SYSTEM FLUSH BUFFER_CACHE;

begin  dbms_result_cache.flush; end;
/ 

connect &1

DECLARE
   t_cust_ids   DBMS_SQL.number_table;
   t_prod_ids   DBMS_SQL.number_table;
   v_prod_id    NUMBER;
   v_cust_id    NUMBER;
   CURSOR c1 IS
      SELECT /*+ RESULT_CACHE */
             *
      FROM       sh.sales
              JOIN
                 sh.products
              USING (prod_id)
           JOIN
              sh.customers
           USING (cust_id)
      WHERE prod_id = v_prod_id AND cust_id = v_cust_id;
BEGIN
   SELECT cust_id
   BULK COLLECT
   INTO t_cust_ids
   FROM customers
   WHERE ROWNUM < 100;

   SELECT prod_id
   BULK COLLECT
   INTO t_prod_ids
   FROM products
   WHERE ROWNUM < 100;

   FOR i IN 1 .. 10000000 LOOP
      v_cust_id := t_cust_ids(round(DBMS_RANDOM.VALUE(1, 10)));
      v_prod_id := t_prod_ids(round(DBMS_RANDOM.VALUE(1, 10)));
      BEGIN
         FOR r IN c1 LOOP
            NULL;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
      END;
   END LOOP;
END;
/

/* Formatted on 26/02/2009 4:48:38 PM (QP5 v5.120.811.25008) */
