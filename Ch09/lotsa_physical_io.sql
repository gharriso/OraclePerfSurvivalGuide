/* Formatted on 2008/10/30 15:31 (Formatter Plus v4.8.7) */
DECLARE
   min_cid   NUMBER;
   max_cid   NUMBER;
   v_cust    sh.customers%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   SELECT MAX (cust_id), MIN (cust_id)
     INTO max_cid, min_cid
     FROM sh.customers;

   FOR v_cid IN min_cid .. max_cid
   LOOP
      BEGIN
         SELECT *
           INTO v_cust
           FROM sh.customers
          WHERE cust_id = v_cid;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END LOOP;
END;

