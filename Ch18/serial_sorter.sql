alter system flush buffer_cache; 
alter system set memory_target=0 scope=memory;
alter system set workarea_size_policy=manual scope=memory;
alter session set sort_area_size=1048576; 
BEGIN
   FOR i IN 1 .. &2 LOOP
      FOR r IN (select * from txn_data where ROWNUM < &1
                ORDER BY 3, 2, 1) LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
/
 
