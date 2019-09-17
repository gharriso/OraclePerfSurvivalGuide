rem
rem sqlplus /nolog @install_opsg
rem
ACCEPT opsg_password   char  PROMPT 'Enter password for the (new) OPSG user:'
ACCEPT sys_password char prompt 'Enter SYS password:' hide
ACCEPT TNS char PROMPT 'Enter TNSNAMES entry:'
connect sys/&&sys_password@&&TNS as sysdba
CREATE USER opsg IDENTIFIED BY &&opsg_password;
GRANT CONNECT, RESOURCE, CREATE SESSION, SELECT_CATALOG_ROLE , CREATE VIEW TO opsg;
GRANT EXECUTE ON dbms_hprof TO opsg;
GRANT CREATE ANY VIEW TO opsg;
ALTER USER hr ACCOUNT UNLOCK IDENTIFIED BY hr;
ALTER USER sh ACCOUNT UNLOCK IDENTIFIED BY sh;
ALTER USER oe ACCOUNT UNLOCK IDENTIFIED BY oe;
GRANT SELECT ON v_$instance TO opsg;
GRANT SELECT ON v_$sys_time_model TO opsg;
GRANT SELECT ON v_$system_event TO opsg;
GRANT SELECT ON v_$timer TO opsg;
GRANT SELECT ON v_$lock TO opsg;
GRANT SELECT ON v_$lock_type TO opsg;
GRANT SELECT ON v_$sysstat TO opsg;
GRANT SELECT ON v_$lock TO opsg;
GRANT SELECT ON v_$lock_type TO opsg;
GRANT SELECT ON dba_objects TO opsg;
GRANT SELECT ON v_$session  TO opsg;
GRANT EXECUTE ON DBMS_LOCK TO opsg;
GRANT EXECUTE ON DBMS_ALERT TO opsg;
GRANT EXECUTE ON DBMS_MONITOR TO opsg;
GRANT SELECT ON v_$osstat TO opsg;
GRANT CREATE JOB TO opsg;
GRANT SELECT ON v_$event_name TO opsg;
GRANT SELECT ON v_$session_event TO opsg;
GRANT SELECT ON v_$sess_time_model TO opsg;
GRANT SELECT ON v_$statname TO opsg;
GRANT SELECT ON v_$mystat TO opsg;
GRANT SELECT ON gv_$system_event TO opsg;
GRANT SELECT ON gv_$sys_time_model TO opsg;
GRANT SELECT ON gv_$service_stats TO opsg;
GRANT SELECT ON gv_$instance TO opsg;
GRANT ALTER SYSTEM TO opsg;
GRANT ALTER SESSION TO opsg;
GRANT EXECUTE ON DBMS_RESOURCE_MANAGER TO opsg;
GRANT EXECUTE ON dbms_rmin TO opsg;
EXEC DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SYSTEM_PRIVILEGE(GRANTEE_NAME => 'OPSG', PRIVILEGE_NAME => 'ADMINISTER_RESOURCE_MANAGER',ADMIN_OPTION => FALSE);
set termout off
GRANT  SELECT ON v_$result_cache_statistics TO opsg;
GRANT EXECUTE ON dbms_result_cache TO opsg;
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
