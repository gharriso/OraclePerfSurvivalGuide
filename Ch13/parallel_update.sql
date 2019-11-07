spool parallel_dml
set echo on
set pages 1000
set lines 120
set timing on 

set serveroutput on
set autotrace on 

create table sales as select * from sh.sales; 
ALTER TABLE sales ADD unit_price number;

alter table sales noparallel ; 
ROLLBACK;
EXPLAIN PLAN
   FOR
      UPDATE /*+ parallel(s)  */
            sales s 
         SET   unit_price = amount_sold / quantity_sold;
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));
COMMIT;
ALTER SESSION ENABLE PARALLEL DML;
ALTER TABLE sales ADD unit_price number;
ALTER TABLE sales_p  ADD unit_price number;

EXPLAIN PLAN
   FOR
      UPDATE /*+ parallel(s)  */
            sales_p s 
         SET   unit_price = amount_sold / quantity_sold;
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

EXPLAIN PLAN
   FOR
      UPDATE /*+ parallel(s) */
            sales s 
         SET   unit_price = amount_sold / quantity_sold;
SELECT   * FROM table (DBMS_XPLAN.display (NULL, NULL, 'BASIC +PARALLEL'));

COMMIT;
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SESSION DISABLE  PARALLEL DML;

UPDATE /*+ parallel(s) */
      sales s 
   SET   unit_price = amount_sold / quantity_sold;
commit; 
/

COMMIT;
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SESSION ENABLE  PARALLEL DML;
UPDATE /*+ parallel(s) */
      sales s 
   SET   unit_price = amount_sold / quantity_sold;
commit; 
/

COMMIT;
ALTER SYSTEM FLUSH BUFFER_CACHE;
 
UPDATE /*+ noparallel(s) */
      sales s 
   SET   unit_price = amount_sold / quantity_sold;
commit; 
/
SELECT   dfo_number, tq_id, server_Type, MIN (num_rows) min_rows,
           MAX (num_rows) max_rows, COUNT ( * ) dop,
           COUNT (DISTINCT instance) no_of_instances
    FROM   v$pq_tqstat
GROUP BY   dfo_number, tq_id, server_Type
ORDER BY   dfo_number, tq_id, server_type DESC;

exit;
/* Formatted on 2-Jan-2009 11:43:43 (QP5 v5.120.811.25008) */
