CREATE OR REPLACE PROCEDURE poor_binds3(p_target_hr NUMBER) IS
   v_dummy              NUMBER;
   v_in                 NUMBER;
   v_end                NUMBER := 1000000;
   v_parse_total        NUMBER;
   v_parse_hard         NUMBER;
   v_parse_total_last   NUMBER;
   v_parse_hard_last    NUMBER;
   v_count              NUMBER := 0;
   v_hit_rate           NUMBER;
   CURSOR c1 IS
      SELECT SUM(DECODE(name, 'parse count (total)', VALUE)) parse_total,
             SUM(DECODE(name, 'parse count (hard)', VALUE)) parse_hard
      FROM    v$mystat
           JOIN
              v$statname
           USING (statistic#)
      WHERE name LIKE '%parse count%';
BEGIN
   OPEN c1;

   FETCH c1 INTO v_parse_total_last, v_parse_hard_last;

   CLOSE c1;

   LOOP
      v_in := ROUND(DBMS_RANDOM.VALUE(1, v_end));

      EXECUTE IMMEDIATE 'select count(*) from txn_data where txn_id=' || v_in
         INTO v_dummy;

      v_count := v_count + 1;
      IF MOD(v_count, 1000) = 0 THEN
         OPEN c1;

         FETCH c1 INTO v_parse_total, v_parse_hard;

         CLOSE c1;

         v_hit_rate :=
            ((v_parse_total - v_parse_total_last)
             - (v_parse_hard - v_parse_hard_last))
            * 100
            / (v_parse_total - v_parse_total_last);
         IF v_hit_rate > p_target_hr THEN
            v_end := v_end * 1.1;
         ELSE
            v_end := v_end * .9;
         END IF;

         INSERT INTO log_table
            SELECT log_table_seq.NEXTVAL,
                   'v_hit_rate=' || v_hit_rate || ', v_end=' || v_end
            FROM DUAL;

         COMMIT;
         v_parse_total_last:=v_parse_total;
         v_parse_hard_last:=v_parse_hard; 
      END IF;
   END LOOP;
END;
/* Formatted on 12-Mar-2009 15:17:01 (QP5 v5.120.811.25008) */
