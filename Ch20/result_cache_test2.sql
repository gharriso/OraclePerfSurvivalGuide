

DECLARE
   t_cust_ids   DBMS_SQL.number_table;
   t_prod_ids   DBMS_SQL.number_table;
   v_prod_id    NUMBER;
   v_cust_id    NUMBER;
   v_time_id    date; 
   CURSOR c1 IS
      SELECT /*+ RESULT_CACHE */
             prod_name ,sum(amount_sold) 
      FROM       sh.sales
              JOIN
                 sh.products
              USING (prod_id)
           JOIN
              sh.customers
           USING (cust_id)
      WHERE cust_id = v_cust_id 
        and time_id>v_time_id 
      group by prod_name ; 
BEGIN
    v_time_id:=sysdate-365; 
   SELECT cust_id
   BULK COLLECT
   INTO t_cust_ids
   FROM customers
   WHERE ROWNUM < 1000;

   SELECT prod_id
   BULK COLLECT
   INTO t_prod_ids
   FROM products
   WHERE ROWNUM < 100;

   FOR i IN 1 .. 10000000 LOOP
      v_cust_id := t_cust_ids(round(DBMS_RANDOM.VALUE(1, 567)));
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
