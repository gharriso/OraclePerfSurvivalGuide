SPOOL subquery2
SET serveroutput on

ALTER SESSION SET tracefile_identifier=subquery2;
ALTER SESSION SET sql_trace=TRUE;
alter session set events '10053 trace name context forever, level 1'; 

SET lines 120
SET pages 10000
SET timing on

select * from hr.employees where (first_name, last_name) in 
 (select cust_first_name,cust_last_name from sh.customers);
