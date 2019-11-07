alter system flush buffer_cache; 
alter system set memory_target=0 scope=memory;
alter system set workarea_size_policy=manual scope=memory;
alter system set sort_area_size=100k scope=memory; 
BEGIN
   FOR i IN 1 .. 1 LOOP
      FOR r IN (SELECT /*+ parallel(t,4) */
                      MAX(tdata)
                FROM txn_data t
                WHERE ROWNUM < 10000000) LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
/
