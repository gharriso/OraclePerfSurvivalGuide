spool bad_parallel
set echo on
set pagesize 1000
set lines 120
set timing on
ALTER TABLE customers PARALLEL(DEGREE 4);
ALTER TABLE sales NOPARALLEL ;
 

EXPLAIN PLAN FOR 
 SELECT /*+ ordered use_hash(c) */
        cust_last_name, SUM (amount_sold)
   FROM sales s JOIN customers c
        USING (cust_id)
  GROUP BY cust_last_name;

SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

DECLARE
   t_names         DBMS_SQL.varchar2_table;
   t_amount_sold   DBMS_SQL.number_table;
BEGIN
     SELECT /*+ ordered use_hash(c) */
           cust_last_name, SUM (amount_sold)
       BULK   COLLECT
       INTO   t_names, t_amount_sold
       FROM      sales s
              JOIN
                 customers c
              USING (cust_id)
   GROUP BY   cust_last_name;
END;
/

/* Formatted on 31/12/2008 4:35:18 PM (QP5 v5.120.811.25008) */
/

alter table sales parallel(degree 4); 

DECLARE
   t_names         DBMS_SQL.varchar2_table;
   t_amount_sold   DBMS_SQL.number_table;
BEGIN
SELECT /*+ ordered use_hash(c) */
              cust_last_name, SUM (amount_sold)
              bulk collect into t_names,t_amount_sold
          FROM    sales s  
          
                 JOIN
                    customers c
                 USING (cust_id)
      GROUP BY   cust_last_name;
END;
/
/

EXPLAIN PLAN
   FOR
        SELECT /*+ ordered use_hash(c) */
              cust_last_name, SUM (amount_sold)
          FROM    sales s  
                 JOIN
                    customers c
                 USING (cust_id)
      GROUP BY   cust_last_name;

SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));
exit;
/* Formatted on 31/12/2008 10:12:03 AM (QP5 v5.120.811.25008) */
