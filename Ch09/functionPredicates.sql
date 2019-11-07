set timing on 
set echo on 
set lines 120
set pages 10000
spool FunctionalIndex

create table sales_f as select * from sh.sales; 
create index sales_f_i1 on sales_f(time_id); 
select min(time_id),max(time_id)  from sales_f;


BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'SALES_F'
                                 );
END;
/

set autotrace on  
 
SELECT SUM (amount_sold)
  FROM sales_f
 WHERE (SYSDATE - time_id) < 10; 
 
SELECT SUM (amount_sold)
  FROM sales_f
 WHERE time_id > sysdate-10 ; 
 
 exit; 
