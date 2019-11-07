

drop table sales; 
create table sales as select * from sh. sales; 

set timing on ;
set autotrace on ; 

update sales set quantity_sold=quanitity_sold+1; 
rollback; 

drop table sales; 
create table sales as select * from sh. sales; 

update sales set quantity_sold=quanitity_sold+1; 
commit; 
