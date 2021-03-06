set echo on 
col event format a30
set autotrace on 


drop table log_data ; 

create table log_data parallel(degree 4) nologging as 
SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
       RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
FROM DUAL
CONNECT BY ROWNUM < &1;

alter table log_data add constraint log_data_pk primary key (id);

alter session enable parallel dml; 

insert /*+ append(l) parallel(l,4) */ into log_data (id,datetime,data) 
 select maxid+id,datetime,data
   from log_data, 
        (select max(id) maxid from log_data); 
commit; 
        
set autotrace off ; 

select * from my_wait_view; 

