spool pq_distribution
set echo on
set pagesize 1000
set lines 120
set timing on
DROP TABLE customers;

CREATE TABLE customers AS
   SELECT   * FROM sh.customers;
begin
    for i in 1..20 loop
        insert into customers
         select * from sh.customers where cust_first_name<'F';
    end loop;
end; 
/

 


BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS');
END;
/
SELECT   *
  FROM   user_tab_col_statistics
 WHERE   table_name = 'CUSTOMERS' AND column_name = 'CUST_LAST_NAME';

EXPLAIN PLAN
   FOR
        SELECT /*+ parallel */
              cust_last_name, cust_first_name, cust_year_of_birth
          FROM   customers
      ORDER BY   CUST_LAST_NAME;
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

DECLARE
BEGIN
   FOR r IN (  SELECT /*+ parallel */
                     cust_last_name, cust_first_name, cust_year_of_birth
                 FROM   customers
             ORDER BY   CUST_LAST_NAME) LOOP
      NULL;
   END LOOP;
END;
/


  SELECT   dfo_number, tq_id, server_Type, MIN (num_rows), MAX (num_rows),
           COUNT ( * ) dop
    FROM   v$pq_tqstat
GROUP BY   dfo_number, tq_id, server_Type
ORDER BY   dfo_number, tq_id, server_type DESC;
ALTER SYSTEM FLUSH SHARED_POOL;
BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS',
   estimate_percent => 100, method_opt => 'FOR ALL COLUMNS SIZE 250');
END;
/
SELECT   *
  FROM   user_tab_col_statistics
 WHERE   table_name = 'CUSTOMERS' AND column_name = 'CUST_LAST_NAME';

DECLARE
BEGIN
   FOR r IN (  SELECT /*+ parallel */
                     cust_last_name, cust_first_name, cust_year_of_birth
                 FROM   customers
             ORDER BY   CUST_LAST_NAME) LOOP
      NULL;
   END LOOP;
END;
/


  SELECT   dfo_number, tq_id, server_Type, MIN (num_rows), MAX (num_rows),
           COUNT ( * ) dop
    FROM   v$pq_tqstat
GROUP BY   dfo_number, tq_id, server_Type
ORDER BY   dfo_number, tq_id, server_type DESC;
/* Formatted on 1/01/2009 5:28:06 PM (QP5 v5.120.811.25008) */
