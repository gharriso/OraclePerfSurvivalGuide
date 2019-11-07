spool explain_plans
set pagesize 1000
set lines 120
set echo on 
rem DROP TABLE sales;
rem DROP TABLE customers;
CREATE TABLE sales AS
   SELECT   * FROM sh.sales;
CREATE TABLE customers AS
   SELECT   * FROM sh.customers;
   
BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/   

EXPLAIN PLAN  FOR
   SELECT   * FROM   customers
 ORDER BY   cust_last_name;

SELECT   * FROM table (DBMS_XPLAN.display 
                 (format=>'BASIC +PARALLEL'));

EXPLAIN PLAN  FOR
   SELECT /*+ parallel */ *
     FROM   customers
 ORDER BY   cust_last_name;

SELECT   * FROM table (DBMS_XPLAN.display 
                 (format=>'BASIC +PARALLEL'));
 
