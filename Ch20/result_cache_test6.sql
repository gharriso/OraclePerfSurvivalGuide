drop table sales_archive; 
create table sales_archive as select * from sh.sales;
create table customers as select * from sh.customers;  
alter system flush shared_pool ; 

DECLARE
   t_cust_ids   DBMS_SQL.number_table;
   t_prod_ids   DBMS_SQL.number_table;
   v_prod_id    NUMBER;
   v_cust_id    NUMBER;
   v_time_id    DATE;
   CURSOR c1 IS
      SELECT /*+ no_result_cache*/
            SUM(amount_sold)
      FROM sales_archive
      WHERE cust_id = v_cust_id;
   CURSOR c2 IS
      SELECT /*+ RESULT_CACHE */
            SUM(amount_sold)
      FROM sales_archive
      WHERE cust_id = v_cust_id;
BEGIN
   SELECT cust_id
   BULK COLLECT
   INTO t_cust_ids
   FROM customers where rownum< 500; 

   FOR i IN 1 .. 10 LOOP
      v_cust_id := t_cust_ids(ROUND(DBMS_RANDOM.VALUE(1, t_cust_ids.count)));
 
      BEGIN
         FOR r IN c1 LOOP
            NULL;
         END LOOP;

         FOR r IN c2 LOOP
            NULL;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
      END;
   END LOOP;
END;
/
select sql_text,executions, elapsed_time from v$sql where sql_text like '%SALES_ARCHIVE%';

/* Formatted on 3/03/2009 3:58:59 PM (QP5 v5.120.811.25008) */
