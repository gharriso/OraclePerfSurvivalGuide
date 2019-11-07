set echo on
col event format a30
set autotrace on
DROP TABLE txn_summary;

CREATE TABLE txn_summary
  AS
   SELECT mod(ROWNUM,99)  txn_type,SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) timestamp,
           DBMS_RANDOM.VALUE(1, 10000) sum_sales ,
           rpad('x',100,'x') other_data
   FROM DUAL
   CONNECT BY ROWNUM < &1;
   
create index txn_summary_i1 on txn_summary(txn_type); 

BEGIN
     sys.dbms_stats.gather_table_stats(OWNNAME=>user, TABNAME=>'TXN_SUMMARY');
 
END;
/

/* Formatted on 21-Feb-2009 13:48:14 (QP5 v5.120.811.25008) */



