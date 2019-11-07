CREATE OR REPLACE PROCEDURE multipass IS
   v_rows              NUMBER := 1000;
   v_disk_sorts        NUMBER := 0;
   v_last_disk_sorts   NUMBER := 0;
   CURSOR c1 IS
      SELECT *
      FROM (SELECT txn_id, datetime, tdata,
                   RANK() OVER (ORDER BY tdata DESC) ranking
            FROM txn_data
            WHERE txn_id < v_rows
            ORDER BY 3, 2, 1)
      WHERE ranking < 1000;
BEGIN
   LOOP
      FOR r IN c1 LOOP
         v_rows := v_rows + 1;
      END LOOP;

      SELECT SUM(VALUE)
      INTO v_disk_sorts
      FROM    sys.v_$mystat
           JOIN
              sys.v_$statname
           USING (statistic#)
      WHERE name IN
                  (
                   'workarea executions - multipass');

      IF (v_disk_sorts - v_last_disk_sorts) = 0 THEN
         v_rows := v_rows * 1.5;
  
      END IF;
      INSERT INTO log_table
         SELECT log_table_seq.NEXTVAL,
                'rows=' || v_rows || ' disk_sorts=' || v_disk_sorts
         FROM DUAL;

      COMMIT;
      v_last_disk_sorts := v_disk_sorts;
   END LOOP;
END;
/* Formatted on 7/03/2009 5:14:11 PM (QP5 v5.120.811.25008) */
