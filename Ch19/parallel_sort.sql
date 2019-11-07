CREATE or replace PROCEDURE parallel_sort is  
BEGIN
      FOR r IN (SELECT /*+ parallel(d,2) */ *
                FROM txn_data d
                ORDER BY tdata, datetime) LOOP
         NULL;
      END LOOP;
 
END;

