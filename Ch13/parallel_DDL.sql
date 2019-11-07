spool parallel_ddl
set echo on
set pages 1000
set lines 120
set serveroutput on

EXPLAIN PLAN FOR                 
CREATE INDEX sales_i ON sales(prod_id,time_id) PARALLEL(DEGREE DEFAULT);
SELECT * FROM table(DBMS_XPLAN.display(NULL, NULL, 'BASIC +PARALLEL'));

EXPLAIN PLAN FOR                 
CREATE  TABLE sales_copy  PARALLEL(DEGREE DEFAULT) AS SELECT * FROM sales;
SELECT * FROM table(DBMS_XPLAN.display(NULL, NULL, 'BASIC +PARALLEL'));
/* Formatted on 2/01/2009 3:26:53 PM (QP5 v5.120.811.25008) */
