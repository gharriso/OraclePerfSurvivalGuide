create table log_data parallel(degree 4) nologging as 
SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
       RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
FROM DUAL
CONNECT BY ROWNUM < &1;

alter table log_data add constraint log_data_pk primary key (id);

