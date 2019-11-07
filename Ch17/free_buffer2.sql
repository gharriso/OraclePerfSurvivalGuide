set echo on 
alter system set db_cache_size=250m scope=memory ; 
alter system set db_keep_cache_size=400M scope=memory ; 
alter session set "_serial_direct_read" = false; 
alter session set tracefile_identifier=free_buffer;
alter session set events '10046 trace name context forever, level 8';


BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => '&1',
   ACTION_NAME => '&1');
END;
/

set echo on 

DROP TABLE opsg2_log_data;

CREATE TABLE opsg2_log_data (id      NUMBER, datetime DATE, data    VARCHAR2(2000)) nologging  storage (buffer_pool keep);

alter table log_etlfile_117 storage(buffer_pool default); 

commit; 


set pages 120 
BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => '&1', ACTION_NAME => '&1');

   INSERT /*+ noappend */
         INTO opsg2_log_data d
      SELECT /*+ cache(e) */ * FROM log_etlfile_117 e;

   COMMIT;
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => 'OPSG',
   ACTION_NAME => 'IDLE');
END;
/



column event format a30

select * from my_wait_view; 

select tracefile from v$session join v$process on (paddr=addr) where audsid=userenv('sessionid'); 

BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => 'OPSG',
   ACTION_NAME => 'IDLE');
END;
/ 
