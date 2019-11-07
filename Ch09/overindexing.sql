spool overindexing
set lines 200
set pages 1000
set timing on 
set echo on 
alter session set statistics_level=all; 

alter session set tracefile_identifier=overindexing;
alter session set sql_trace true; 


drop table customers_oi; 
create table customers_oi as select * from sh.customers; 
update customers_oi set cust_email=cust_last_name||cust_id||'@company.com';
update customers_oi set cust_email='Sydney.Tang@company.com' where cust_id=104496; 
alter table customers_oi move; 


create index customers_oi_name_idx on customers_oi (cust_last_name,cust_first_name,cust_email); 

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS_OI'
                                 );
END;
/

set autotrace off 
 
 
/* Formatted on 2008/10/12 22:17 (Formatter Plus v4.8.7) */
SELECT /*+ gather_plan_statistics */
cust_main_phone_number
  FROM customers_oi
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney'
   AND cust_email = 'Sydney.Tang@company.com';
   
select * from table(dbms_xplan.display_cursor(null,null,'BASIC +IOSTATS'));    

 
 drop index customers_oi_name_idx; 
 create unique index customers_oi_name_un_idx on customers_oi (cust_last_name,cust_first_name,cust_email); 
 SELECT /*+ gather_plan_statistics */
cust_main_phone_number
  FROM customers_oi
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney'
   AND cust_email = 'Sydney.Tang@company.com';
   
select * from table(dbms_xplan.display_cursor(null,null,'BASIC +IOSTATS'));       
 
 create unique index customers_oi_name_phone_idx on customers_oi (cust_last_name,cust_first_name,cust_email,cust_main_phone_number);  
 
/* Formatted on 2008/10/12 22:08 (Formatter Plus v4.8.7) */
SELECT /*+ gather_plan_statistics */
cust_main_phone_number
  FROM customers_oi
 WHERE cust_last_name = 'Tang'
   AND cust_first_name = 'Sydney'
   AND cust_email = 'Sydney.Tang@company.com';
   
select * from table(dbms_xplan.display_cursor(null,null,'BASIC +IOSTATS'));       

 
exit; 
