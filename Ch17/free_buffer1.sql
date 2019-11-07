alter system set db_cache_size=150m scope=memory ; 
alter system set db_keep_cache_size=50M scope=memory ; 
alter session set "_serial_direct_read" = false; 

DROP TABLE opsg2_log_data;

CREATE TABLE opsg2_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000)) nologging  storage (buffer_pool keep);



commit; 

set autotrace on 

insert /*+noappend  */ into opsg2_log_data d 
select /*+ noparallel(l) cache */  * from log_data l where rownum <&1; 

commit; 
set autotrace off
column event format a30

select * from my_wait_view; 
