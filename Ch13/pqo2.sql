SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL pqo2
set arraysize 100
ALTER SESSION SET tracefile_identifier=pqo2;
ALTER SESSION SET sql_trace=TRUE;
DROP TABLE sales;
DROP TABLE products;

CREATE TABLE sales AS
   SELECT   * FROM sh.sales;

CREATE TABLE products AS
   SELECT   * FROM sh.products;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'PRODUCTS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/



set autotrace on


                 
  SELECT /*+  parallel(s,2)   */
        prod_id, cust_id, time_id, SUM (amount_sold)
    FROM   sales s
GROUP BY   prod_id, cust_id, time_id
ORDER BY   4 DESC;   

delete from plan_table ; 
explain plan for 
  SELECT /*+  parallel(s,2)   */
        prod_id, cust_id, time_id, SUM (amount_sold)
    FROM   sales s
GROUP BY   prod_id, cust_id, time_id
ORDER BY   4 DESC;

select * from table(dbms_xplan.display()); 
     
  SELECT   MAX (COUNT (DISTINCT process))
    FROM   v$pq_tqstat t
   WHERE   dfo_number = (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
           AND server_type LIKE 'Producer%'
GROUP BY   tq_id, server_type; 
/* Formatted on 24-Dec-2008 7:12:20 (QP5 v5.120.811.25008) */
 
WITH plan_table_v AS
       (SELECT   p.*, CASE operation
                         WHEN 'PX SEND' THEN 'Producer'
                         WHEN 'PX RECEIVE' THEN 'Consumer'
                         WHEN 'PX BLOCK' THEN 'Producer'
                         ELSE 'Consumer'
                      END
                         server_type
          FROM   plan_table p
         WHERE   plan_id = (SELECT   MAX (plan_id) FROM plan_table)),
    tqstat AS
       (  SELECT   ':Q1' || LTRIM (TO_CHAR (tq_id, '000')) object_node,
                   substr(server_type,1,7) server_type, AVG (num_rows) avg_rows, MIN (num_rows) min_rows,
                   MAX (num_rows) max_rows, COUNT ( * ) actual_dop
            FROM   v$pq_tqstat t
           WHERE   dfo_number = (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
        GROUP BY   tq_id, server_type)
SELECT   operation ,max_rows,min_rows,object_node||'.',rtrim(server_type)||'.'
  FROM      plan_table_v
         FULL OUTER JOIN
            tqstat
         USING (object_node, server_type)
/* Formatted on 23/12/2008 5:11:13 PM (QP5 v5.120.811.25008) */
