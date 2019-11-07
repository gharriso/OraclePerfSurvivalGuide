set echo on 
set lines 120 
set pagesize 1000

EXPLAIN PLAN FOR 
select * from sh.sales order by cust_id,prod_id,time_id; 

select * from table(dbms_xplan.display()); 
