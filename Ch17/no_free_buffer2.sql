alter system set db_cache_size=150m scope=memory ; 
alter system set db_keep_cache_size=150M scope=memory ; 
alter session set "_serial_direct_read" = false; 
alter session set tracefile_identifier=free_buffer;
alter session set events '10046 trace name context forever, level 8';

BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => 'FREEBUFFER_TEST',
   ACTION_NAME => 'FREEBUFFER_TEST');
END;
/


DROP TABLE opsg2_log_data;

CREATE TABLE opsg2_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000)) nologging  storage (buffer_pool keep);

commit; 

set autotrace on 
set pages 120 

insert /*+ noappend */ into opsg2_log_data d 
select  * from log_etlfile_117;

commit; 
set autotrace off
column event format a30

select * from my_wait_view; 

select tracefile from v$session join v$process on (paddr=addr) where audsid=userenv('sessionid'); 
exit; 
