rem *********************************************************** 
rem
rem	File: loginTrigger.sql 
rem	Description: Example of a login trigger that activates SQL trace
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 3 Page 58
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


CREATE OR REPLACE TRIGGER SYSTEM.trace_login_trigger
AFTER LOGON
ON DATABASE
BEGIN
IF SYS_CONTEXT ('USERENV', 'MODULE')  LIKE '%TOAD%'
   THEN
   
      DBMS_SESSION.session_trace_enable (waits  => TRUE,
                                             binds  => FALSE);
      EXECUTE IMMEDIATE 'alter session set tracefile_identifier=TOAD';

   END IF;
END;
