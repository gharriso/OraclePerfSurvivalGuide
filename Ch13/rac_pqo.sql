spool rac_pqo
set echo on
set pagesize 1000
set lines 120
set timing on
rem ALTER SYSTEM SET parallel_threads_per_cpu=2  SCOPE=MEMORY;
rem ALTER SYSTEM SET parallel_max_servers=40 SCOPE=MEMORY; 
 
 
SELECT   *
  FROM   v$parameter
 WHERE   name LIKE '%cpu%';
set autotrace on
 

EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(s)  */
            COUNT ( * )
        FROM   sales s;
SELECT   * FROM table (DBMS_XPLAN.display ());

set autotrace on 

select * from (
    SELECT /*+ parallel(s) parallel(c) */
        cust_last_name,sum(amount_sold) as
  FROM   sh.sales s join sh.customers c using (cust_id) group by cust_last_name order by 2 desc )
where rownum <10; 

 
  
column dop format 9999
 
SELECT   dfo_number, tq_id, server_Type, MIN (num_rows) min_rows,
           MAX (num_rows) max_rows, COUNT ( * ) dop,
           COUNT (DISTINCT instance) no_of_instances
    FROM   v$pq_tqstat
GROUP BY   dfo_number, tq_id, server_Type
ORDER BY   dfo_number, tq_id, server_type DESC;
/* Formatted on 1/01/2009 9:25:48 PM (QP5 v5.120.811.25008) */
