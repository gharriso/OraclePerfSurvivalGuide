CREATE OR REPLACE PACKAGE txn_sim IS
   PROCEDURE txn(p_sleep_time NUMBER);

   PROCEDURE txn_stop;

   PROCEDURE txn_loop(max_sleep NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY txn_sim IS
   PROCEDURE txn(p_sleep_time NUMBER) IS
      v_cust_ids        DBMS_SQL.number_table;
      v_cust_id         NUMBER;
      v_quantity_sold   NUMBER;
   BEGIN
      select /*+ full(s) parallel(s) */ distinct cust_id BULK COLLECT
      INTO v_cust_ids from sales s where amount_sold > 10 
      /* order by dbms_random.value(0,5) */; 


      FOR i IN 1 .. least(v_cust_ids.LAST,20) LOOP
         SELECT cust_id
         INTO v_cust_id
         FROM customers
         WHERE cust_id = v_cust_ids(i) ;

         /*SELECT SUM(quantity_sold)
         INTO v_quantity_sold
         FROM sales
         WHERE cust_id = v_cust_id;*/

         UPDATE customers
         SET cust_valid = 'I'
         WHERE cust_id = v_cust_id;
      END LOOP;

      DBMS_LOCK.sleep(p_sleep_time);
      ROLLBACK;

   END;

PROCEDURE txn_loop(max_sleep NUMBER) IS
   x          INT;
   l_status   NUMBER;
   l_dummy    VARCHAR2(1000);
   l_sleep    number; 
BEGIN
   sys.DBMS_ALERT.REGISTER('TXN_STOP');

   LOOP
      l_sleep:=round(DBMS_RANDOM.VALUE(0, max_sleep)); 
      txn(l_sleep);

      DBMS_ALERT.waitone(NAME => 'TXN_STOP', status => l_status,
      MESSAGE => l_dummy, TIMEOUT => ROUND(l_sleep));

      IF l_status = 0 THEN
         EXIT;
      END IF;
   END LOOP;
END;

PROCEDURE txn_stop IS
BEGIN
   DBMS_ALERT.signal('TXN_STOP', 'stop');
   COMMIT;
END;

END;

/
/* Formatted on 24/01/2009 3:38:31 PM (QP5 v5.120.811.25008) */
