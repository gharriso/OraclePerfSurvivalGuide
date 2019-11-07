rem 
rem sqlplus /nolog @install_opsg
rem
 
ACCEPT opsg_password   char  PROMPT 'Enter password for the (new) OPSG user:'
ACCEPT sys_password char prompt 'Enter SYS password:' hide
ACCEPT TNS char PROMPT 'Enter TNSNAMES entry:' 

connect sys/&&sys_password@&&TNS as sysdba
create user opsg identified by &&opsg_password; 
grant connect, resource, create session, select_catalog_role , create view to opsg;
grant execute on dbms_hprof to opsg; 
grant create any view to opsg; 
alter user hr account unlock identified by hr;
alter user sh account unlock identified by sh; 
alter user oe account unlock identified by oe; 
grant select on v_$instance to opsg; 
grant select on v_$sys_time_model to opsg; 
grant select on v_$system_event to opsg; 
grant select on v_$timer to opsg; 
grant select on v_$lock to opsg; 
grant select on v_$lock_type to opsg; 
grant select on v_$sysstat to opsg; 
grant select on v_$lock to opsg; 
grant select on v_$lock_type to opsg; 
grant select on dba_objects to opsg; 
grant select on v_$session  to opsg; 
grant execute on dbms_lock to opsg; 
grant execute on dbms_alert to opsg; 
grant execute on dbms_monitor to opsg; 
grant select on v_$osstat to opsg;
grant create job to opsg; 
grant select on v_$event_name to opsg; 
grant select on v_$session_event to opsg; 
grant select on v_$sess_time_model to opsg; 
grant select on v_$statname to opsg; 
grant select on v_$mystat to opsg; 
grant select on gv_$system_event to opsg; 
grant select on gv_$sys_time_model to opsg; 
grant select on gv_$service_stats to opsg;
grant select on gv_$instance to opsg; 
grant alter system to opsg; 
grant alter session to opsg; 

set termout off
grant  select on v_$result_cache_statistics to opsg; 
grant execute on dbms_result_cache to opsg; 
set termout on 


connect hr/hr@&&TNS;
@@hr_grants
connect sh/sh@&&TNS;
@@sh_grants
connect oe/oe@&&TNS;
@@oe_grants

connect opsg/&&opsg_password@&&TNS; 

set termout on
@@opsg_time_model_typ
@@opsg_systat_typ
@@opsg_racstat_typ
@@opsg_servicestat_typ


set termout on 

@@OPSG_PKG_ddl
/

@@OPSG_DATALOAD.psk
/
@@OPSG_DATALOAD.pbk
/
@@opsg_delta_report_vw.sql
/
@@lock_mode_function.sql
/ 
@@v_my_locks.sql  
/
@@lock_delta_view.sql
/
@@latch_delta_view.sql
/
@@my_wait_view.sql
/
@@hit_rate_delta_view.sql
/
@@direct_io_delta_view.sql
/
@@io_time_delta_view.sql
/
set termout off

@@result_cache_pkg.sql

set termout on 


