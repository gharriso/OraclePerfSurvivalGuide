CREATE OR REPLACE PROCEDURE disk_sorts(n_rows NUMBER) IS
   v_rows              NUMBER := n_rows;
   v_disk_sorts        NUMBER := 0;
   v_last_disk_sorts   NUMBER := 0;
   CURSOR c1 IS
      SELECT *
      FROM (SELECT ROWNUM txn_id, SYSDATE + MOD(ROWNUM, 1000) - 500 datetime,
                   RPAD(CHR(MOD(ROWNUM, 20) + 20), MOD(ROWNUM, 1000) + 1,
                   ROWNUM)
                   || CHR(MOD(ROWNUM, 20) + 30)||dbms_random.value(1,10)
                      txn_data
            FROM (SELECT ROWNUM r
                  FROM DUAL
                  CONNECT BY ROWNUM <= 1000) a, (SELECT ROWNUM r
                                                 FROM DUAL
                                                 CONNECT BY ROWNUM <= 1000) b,
                 (SELECT ROWNUM r
                  FROM DUAL
                  CONNECT BY ROWNUM <= 1000) c
            WHERE ROWNUM <= v_rows
            ORDER BY 3 DESC, 2 DESC, 1)
      WHERE ROWNUM < 1000;
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


      INSERT INTO log_table
         SELECT log_table_seq.NEXTVAL,
                'rows=' || n_rows || ' disk_sorts=' || v_disk_sorts
         FROM DUAL;

      COMMIT;
      v_last_disk_sorts := v_disk_sorts;
   END LOOP;
END;
/* Formatted on 7-Mar-2009 21:41:27 (QP5 v5.120.811.25008) */
