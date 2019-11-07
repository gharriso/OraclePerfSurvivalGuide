CREATE OR REPLACE PROCEDURE periodic_scan(v_sleep_time NUMBER) IS
   v_status      NUMBER;
   v_dummy       VARCHAR2(1000);
   t_txn_type    DBMS_SQL.number_table;
   t_timestamp   DBMS_SQL.date_table;
   t_sum_sales   DBMS_SQL.number_table;
BEGIN
   EXECUTE IMMEDIATE 'alter session set "_serial_direct_read"=false ';

   EXECUTE IMMEDIATE 'alter system flush shared_pool  ';

   DBMS_ALERT.REGISTER('GHR_STOP'); -- end run


   LOOP
 
         SELECT txn_type, timestamp, sum_sales
         BULK COLLECT
         INTO t_txn_type, t_timestamp, t_sum_sales
         FROM txn_summary ts ; 
 


      DBMS_LOCK.sleep(ROUND(v_sleep_time * DBMS_RANDOM.VALUE(-.5, 1.5)));

      DBMS_ALERT.waitone(NAME => 'GHR_STOP', status => v_status,
      MESSAGE => v_dummy, TIMEOUT => 0);
      IF v_status = 0 THEN
         EXIT;
      END IF;
   END LOOP;
END;
/* Formatted on 21-Feb-2009 13:53:07 (QP5 v5.120.811.25008) */ 
