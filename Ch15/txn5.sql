DECLARE
   lx   NUMBER;
BEGIN
   LOOP
      FOR r IN (SELECT *
                FROM sales where cust_id = 100667 
                FOR UPDATE ) LOOP
         NULL;
      END LOOP;

      COMMIT;
   END LOOP;
END;
/

/* Formatted on 24/01/2009 10:36:42 PM (QP5 v5.120.811.25008) */
