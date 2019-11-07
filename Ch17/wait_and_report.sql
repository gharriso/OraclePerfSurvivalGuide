rem
rem Sleep for &1 seconds, then wait until all sessions with module=&2 have
rem disconnected, then print wait report
rem
create table free_buffer_data(runtag varchar2(30),event varchar2(1000), ms
      number);

DELETE FROM free_buffer_data
WHERE runtag = '&2';

COMMIT;

alter package opsg_pkg compile; 

SELECT COUNT( * ) FROM TABLE (opsg_pkg.wait_time_report ('RESET')); 

set serveroutput on
set verify off

DECLARE
   v_count   NUMBER;
BEGIN
   DBMS_LOCK.sleep(&1);

   LOOP
      SELECT COUNT( * )
      INTO v_count
      FROM v$session
      WHERE module = '&2';

      EXIT WHEN v_count = 0;
      DBMS_LOCK.sleep(&1);
   END LOOP;

   DBMS_OUTPUT.put_line('No session with module=&2 ');



   INSERT INTO free_buffer_data(runtag, event, ms)
      SELECT '&2', stat_name,
             ROUND(sample_seconds * microseconds_per_second / 1000) ms
      FROM opsg_delta_report
      WHERE stat_name <> 'Other';

   COMMIT;
END;
/

/* Formatted on 12-Feb-2009 21:05:29 (QP5 v5.120.811.25008) */


rem Other is CPU wait & network


column sample_seconds format 99,999 heading "Secs"
column event format a30
column runtag format a20
column ms_ps format 999999999
column pct_of_time format 99.99 heading "pct"
set pages 1000
set lines 100

select * from free_buffer_data where runtag='&2' 
 and ms>1000
 order by ms desc ; 

