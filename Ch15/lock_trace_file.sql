prompt lock_trace_file
ALTER SESSION SET tracefile_identifier=lock_waits2;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
ALTER SYSTEM FLUSH BUFFER_CACHE;

BEGIN
   DBMS_APPLICATION_INFO.set_module('OPSG', 'LOCK_TEST');
END;
/

BEGIN
   DBMS_APPLICATION_INFO.set_module('OPSG', 'LOCK_TEST');

   FOR r IN (SELECT * FROM customers) LOOP
      BEGIN
         DBMS_APPLICATION_INFO.set_module('OPSG', 'LOCK_TEST');

         FOR r2 IN (SELECT *
                    FROM customers
                    WHERE cust_id = r.cust_id
                    FOR UPDATE WAIT 1) LOOP
            NULL;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      COMMIT;
   END LOOP;
END;
/

/* Formatted on 25/01/2009 11:47:48 AM (QP5 v5.120.811.25008) */
