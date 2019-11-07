alter session set COMMIT_WAIT = NOWAIT;
alter session set COMMIT_LOGGING = BATCH; 

DECLARE
   v_datetime   DATE;
   v_vnum       NUMBER;
   l_elapsed    NUMBER := 0;
   l_start      NUMBER;
   iter         NUMBER := 0;
BEGIN
   l_start := DBMS_UTILITY.get_time();

   WHILE (l_elapsed < &1) LOOP
      FOR r IN (SELECT ROWID
                FROM bb_data
                WHERE id < 10) LOOP
         v_datetime := SYSDATE;
         v_vnum := DBMS_RANDOM.VALUE(1, 1000);

         UPDATE bb_data
         SET datetime = v_datetime, nval = v_vnum
         WHERE ROWID = r.ROWID;

         COMMIT;
      END LOOP;

      IF (MOD(iter, 1000) = 0) THEN
         l_elapsed := (DBMS_UTILITY.get_time() - l_start) / 100;
      END IF;
   END LOOP;
END;
/* Formatted on 15/02/2009 10:01:07 AM (QP5 v5.120.811.25008) */
/

