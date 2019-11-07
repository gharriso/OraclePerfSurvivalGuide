set echo on 
col event format a30
set autotrace on 


drop table bb_data ; 

create table bb_data parallel(degree 1) nologging as 
SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
       dbms_random.value(1,10000) nval, rpad('x',200,'x') vval 
FROM DUAL
CONNECT BY ROWNUM < 1000;

alter table bb_data add constraint bb_data_pk primary key (id);

BEGIN
   DBMS_STATS.gather_table_stats(OWNNAME => USER, TABNAME => 'BB_DATA');
END;
/ 


