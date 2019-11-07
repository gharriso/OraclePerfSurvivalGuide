rem *********************************************************** 
rem
rem	File: tqstat2.sql 
rem	Description: Example of using v$pq_tqstat to reveal PQO workload distribution 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 13 Page 413
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pagesize 1000
set lines 120
set echo on
spool tqstat
set autotrace on

  SELECT /*+ parallel */
        prod_id, SUM (amount_sold)
    FROM   sales
GROUP BY   prod_id
ORDER BY   2 DESC;
set autotrace off

BEGIN
   DBMS_LOCK.sleep (2);
END;
/
EXPLAIN PLAN
   FOR
        SELECT /*+ parallel */
              prod_id, SUM (amount_sold)
          FROM   sales
      GROUP BY   prod_id
      ORDER BY   2 DESC;

SELECT   * FROM table (DBMS_XPLAN.display (format => 'basic +parallel'));

  SELECT   dfo_number, tq_id, server_Type, MIN (num_rows), MAX (num_rows),count(*) dop 
    FROM   v$pq_tqstat
GROUP BY   dfo_number, tq_id, server_Type
ORDER BY   dfo_number, tq_id, server_type DESC;
exit;
/* Formatted on 30/12/2008 2:43:02 PM (QP5 v5.120.811.25008) */
