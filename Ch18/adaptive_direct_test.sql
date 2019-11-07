alter system flush shared_pool ;
alter system flush buffer_cache; 
alter system set "_adaptive_direct_read"=false scope=spfile;
alter system set filesystemio_options='setall' scope=spfile; 
alter session set "_small_table_threshold"=9000; 
 
select * from user_tables where table_name = 'TXN_SUMMARY' ; 
set autotrace on 
set lines 100
set pages 1000
select  max(sum_sales) from txn_summary;

/


 
column event format a20
select * from my_wait_view; 
/

