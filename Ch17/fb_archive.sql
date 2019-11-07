CREATE TABLESPACE fb_arc_ts1 DATAFILE
  '/app/oracle/oradata/G11R2/datafile/fb_arc1.dbf' SIZE 1024 M AUTOEXTEND OFF;
DROP FLASHBACK ARCHIVE fb_arc1;
CREATE FLASHBACK ARCHIVE DEFAULT fb_arc1
   TABLESPACE fb_arc_ts1
   QUOTA 1024 M
   RETENTION 1 DAY;
grant flashback archive on fb_arc1 to opsg; 
GRANT FLASHBACK ARCHIVE ADMINISTER TO OPSG; 

ALTER TABLE fba_test_data NO FLASHBACK ARCHIVE;
DROP TABLE fba_test_data;
DROP TABLE nonfba_test_data;

CREATE TABLE fba_test_data AS
   SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
          RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
   FROM DUAL
   CONNECT BY ROWNUM < 1000;

CREATE TABLE nonfba_test_data AS
   SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
          RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
   FROM DUAL
   CONNECT BY ROWNUM < 1000;

ALTER TABLE fba_test_data FLASHBACK ARCHIVE;
ALTER SESSION SET tracefile_identifier=fba;

BEGIN
   DBMS_SESSION.session_trace_enable(waits => TRUE, binds => FALSE);

   FOR r IN (SELECT sid, serial#
             FROM v$session
             WHERE program LIKE '%FBDA%') LOOP
      DBMS_MONITOR.session_trace_enable(session_id => R.SID,
      serial_num => R.serial#, waits => TRUE, binds => FALSE);
   END LOOP;
END;
/

set echo on
set timing on
ALTER SYSTEM FLUSH BUFFER_CACHE;

INSERT INTO nonfba_test_data d(id, datetime, data)
   SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
          RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
   FROM DUAL
   CONNECT BY ROWNUM < 1000000;

COMMIT;

UPDATE nonfba_test_data
SET datetime = datetime + .01;

COMMIT;
ALTER SYSTEM FLUSH BUFFER_CACHE;

INSERT INTO fba_test_data d(id, datetime, data)
   SELECT ROWNUM id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
          RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') data
   FROM DUAL
   CONNECT BY ROWNUM < 1000000;

COMMIT;

UPDATE fba_test_data
SET datetime = datetime + .01;

COMMIT;

COMMIT;
/* Formatted on 4-Feb-2009 15:00:55 (QP5 v5.120.811.25008) */
