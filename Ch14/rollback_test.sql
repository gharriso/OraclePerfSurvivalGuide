spool rollback_test

drop table sales; 
create table sales as select * from sh. sales; 

set timing on ;
set autotrace on ; 
set echo on ; 


update sales set quantity_sold=quantity_sold+1; 
rollback; 

drop table sales; 
create table sales as select * from sh. sales; 

update sales set quantity_sold=quantity_sold+1; 
commit; 
exit; 

