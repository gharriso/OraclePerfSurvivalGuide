CREATE OR REPLACE PROCEDURE disk_sorts2 IS
   v_rows              NUMBER := 1000;
   v_disk_sorts        NUMBER := 0;
   v_last_disk_sorts   NUMBER := 0;
   CURSOR c1 IS
      SELECT *
      FROM (SELECT *
            FROM (SELECT ROWNUM txn_id,
                         SYSDATE + DBMS_RANDOM.VALUE(1, 1000) datetime,
                         RPAD(CHR(DBMS_RANDOM.VALUE(24, 82)), DBMS_RANDOM.VALUE(1,
                                                              100), ROWNUM)
                            txn_data, RANK() OVER (ORDER BY ROWNUM DESC) ranking
                  FROM (SELECT ROWNUM r
                        FROM DUAL
                        CONNECT BY ROWNUM <= 1000) a,
                       (SELECT ROWNUM r
                        FROM DUAL
                        CONNECT BY ROWNUM <= 1000) b,
                       (SELECT ROWNUM r
                        FROM DUAL
                        CONNECT BY ROWNUM <= 1000) c
                  WHERE ROWNUM <= v_rows
                  ORDER BY 3, 2, 1))
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
                  ('workarea executions - onepass',
                   'workarea executions - multipass');

      IF (v_disk_sorts - v_last_disk_sorts) = 0 THEN
         v_rows := v_rows * 2;
      END IF;

      INSERT INTO log_table
         SELECT log_table_seq.NEXTVAL,
                'rows=' || v_rows || ' disk_sorts=' || v_disk_sorts
         FROM DUAL;

      COMMIT;
      v_last_disk_sorts := v_disk_sorts;
   END LOOP;
END;
/* Formatted on 7/03/2009 6:30:32 PM (QP5 v5.120.811.25008) */
