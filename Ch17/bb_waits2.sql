alter session set COMMIT_WAIT = NOWAIT;
alter session set COMMIT_LOGGING = BATCH;
alter session set tracefile_identifier=buffer_busy; 
 
alter system set RESOURCE_MANAGER_CPU_ALLOCATION=20 scope=memory; 
alter session set events '10046 trace name context forever, level 8'; 

BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => '&2',
   ACTION_NAME => '&2');
END;
/
DECLARE
   v_datetime   DATE;
   v_vnum       NUMBER;
   l_elapsed    NUMBER := 0;
   l_start      NUMBER;
   iter         NUMBER := 0;
BEGIN
   l_start := DBMS_UTILITY.get_time();

   WHILE (l_elapsed < &1) LOOP
      FOR r IN (SELECT ROWID,id
                FROM bb_data
                WHERE id < 10) LOOP
         v_datetime := SYSDATE;
         v_vnum := DBMS_RANDOM.VALUE(1, 1000);

         UPDATE bb_data
         SET datetime = v_datetime, nval = v_vnum
         WHERE id=r.id;

         COMMIT;
      END LOOP;

      IF (MOD(iter, 1000) = 0) THEN
         l_elapsed := (DBMS_UTILITY.get_time() - l_start) / 100;
      END IF;
   END LOOP;
END;

/
BEGIN
   DBMS_APPLICATION_INFO.set_module(MODULE_NAME => 'OPSG',
   ACTION_NAME => 'IDLE');
END;
/
select tracefile from v$session join v$process on (paddr=addr) where audsid=userenv('sessionid'); 

