EXPLAIN PLAN FOR 
SELECT SUM (amount_sold) employee_purchases
  FROM hr.employees e, sh.customers c, sh.sales s
 where e.first_name=c.cust_first_name
    and e.last_name=c.cust_last_name
    and s.cust_id=c.cust_id
    and manager_id=100
/
SELECT * FROM TABLE( DBMS_XPLAN.DISPLAY ( null,null,'BASIC +COST' ))
/
ALTER SESSION SET "_use_nosegment_indexes"=TRUE;
create index sh.customers_vi1 on sh.customers(cust_first_name,cust_last_name) nosegment;
create index hr.employees_vi1 on hr.employees(manager_id) nosegment; 
create index sh.sales_vi1 on sh.sales(cust_id) nosegment; 


EXPLAIN PLAN FOR 
SELECT SUM (amount_sold) employee_purchases
  FROM hr.employees e, sh.customers c, sh.sales s
 where e.first_name=c.cust_first_name
    and e.last_name=c.cust_last_name
    and s.cust_id=c.cust_id
        and employee_id=1
/
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY (null,null,'BASIC +COST'))
/
drop index sh.customers_vi1;
drop index hr.employees_vi1; 
drop index sh.sales_vi1 ;

 
       

