/* Formatted on 2008/11/23 09:15 (Formatter Plus v4.8.7) */
set lines 200
set pages 10000
set echo on 
spool sort_xplan 

ALTER SYSTEM FLUSH SHARED_POOL;
alter session set sort_area_size=104857600; 
alter session set statistics_level=all; 
 
drop table customers;
create table customers as select * from sh.customers; 
insert into customers select * from customers;

create index cust_namedob_i on customers (cust_last_name, cust_first_name, cust_year_of_birth); 
 
select * from (
SELECT   /*+ FULL(c)  */  *
   FROM customers c
  ORDER BY cust_last_name, cust_first_name, cust_year_of_birth) where rownum=1;
             
 

   
var sql_id varchar2(20);
var child_number number; 
/* Formatted on 2008/11/23 20:47 (Formatter Plus v4.8.7) */
BEGIN
   SELECT sql_id, child_number
     INTO :sql_id, :child_number
     FROM v$sql
    WHERE sql_text LIKE
                       '%cust_last_name, cust_first_name, cust_year_of_birth%'
      AND sql_text NOT LIKE '%sql_id%'
      AND sql_text NOT LIKE 'explain%'
      and upper(sql_text) not like 'BEGIN%'
      AND ROWNUM = 1;
END;
/


SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (:sql_id,:child_number,'MEMSTATS -IOSTATS'));


explain plan for  SELECT      *
 FROM customers
  ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;
  
  SELECT *
  FROM TABLE (DBMS_XPLAN.display ( ));
  
explain plan for  
SELECT /*+ INDEX(c) */     *
 FROM customers c
  ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;
  
  SELECT *
  FROM TABLE (DBMS_XPLAN.display ( ));
  
explain plan for  
SELECT /*+ FIRST_ROWS  */     *
 FROM customers c
  ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;
  
  SELECT *
  FROM TABLE (DBMS_XPLAN.display ( ));
  
  exit; 
