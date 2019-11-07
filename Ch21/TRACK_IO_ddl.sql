CREATE OR REPLACE PROCEDURE track_io(p_samples     NUMBER,
                   p_interval    NUMBER) IS
BEGIN
    execute immediate 'alter system flush buffer_cache'; 
   FOR i IN 1 .. p_samples LOOP
      INSERT INTO io_wait_log
         SELECT *
         FROM opsg_delta_report
         WHERE stat_name = 'db file sequential read';
         commit; 

      DBMS_LOCK.sleep(p_interval);
   END LOOP;
END;
/* Formatted on 20-Mar-2009 19:43:09 (QP5 v5.120.811.25008) */
