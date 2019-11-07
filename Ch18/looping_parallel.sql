create procedure looping_parallel is 
begin 
   FOR i IN 1 .. 100 LOOP
      FOR r IN (SELECT /*+ parallel(t,4) */
                      MOD(txn_id, 9), MAX(tdata)
                FROM txn_data
                GROUP BY MOD(txn_id, 9)
                ORDER BY MOD(txn_id, 9)) LOOP
         NULL;
      END LOOP;
   END LOOP;
END;

