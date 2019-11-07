BEGIN
   LOOP
      FOR i IN 1 .. &1 LOOP
         FOR r IN (SELECT *
                   FROM txn_data
                   WHERE txn_id = i) LOOP
            NULL;
         END LOOP;
      END LOOP;
   END LOOP;
END;
/

/* Formatted on 22/02/2009 9:09:17 PM (QP5 v5.120.811.25008) */
