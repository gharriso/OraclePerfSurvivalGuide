column query_plan format a55
column cardinality format 99999
column cost format 99999
delete from plan_table;
set lines 100
set pages 100
set echo on 

EXPLAIN PLAN FOR
SELECT *
  FROM hr.employees JOIN hr.departments USING (department_id);
 
 SELECT RTRIM (LPAD (' ', 2 * LEVEL) || 
       RTRIM (operation) || ' ' || 
       RTRIM (options) || ' ' || 
              object_name) query_plan,
       cost, cardinality 
  FROM plan_table
 CONNECT BY PRIOR id = parent_id
 START WITH id = 0 ; 

SELECT * FROM TABLE(dbms_xplan.display()); 
