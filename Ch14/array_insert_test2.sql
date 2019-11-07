drop table sales; 
create table sales as select * from sh.sales where rownum <0; 
drop table array_insert_data;
create table array_insert_data(seq number,array_size number, microseconds number); 

 
