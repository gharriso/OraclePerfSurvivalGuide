CREATE OR REPLACE PROCEDURE io_1m IS
    tid number; 
BEGIN
   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   FOR i IN 1 .. 1000000 LOOP
      -- tid:=dbms_random.value(1,1000000); 
      FOR r IN (SELECT *
                FROM txn_data32
                WHERE txn_id = i) LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
