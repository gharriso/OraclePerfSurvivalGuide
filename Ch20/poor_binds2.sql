CREATE or replace PROCEDURE poor_binds3(p_target_hr NUMBER) IS
   v_dummy              NUMBER;
   v_in                 NUMBER;
   v_end                NUMBER := 1000000;
   v_parse_total        NUMBER;
   v_parse_hard         NUMBER;
   v_parse_total_last   NUMBER;
   v_parse_hard_last    NUMBER;
   v_count              NUMBER := 0;
   v_hit_rate number; 
   CURSOR c1 IS
      SELECT SUM(DECODE(name, 'parse count (total)', VALUE)) parse_total,
             SUM(DECODE(name, 'parse count (hard)', VALUE)) parse_hard
      FROM v$sysstat
      WHERE name LIKE '%parse count%';
BEGIN
   LOOP
      OPEN c1;

      FETCH c1 INTO v_parse_total_last, v_parse_hard_last;

      CLOSE c1;

      v_in := ROUND(DBMS_RANDOM.VALUE(1, v_end));

      EXECUTE IMMEDIATE 'select count(*) from txn_data where txn_id=' || v_in
         INTO v_dummy;

      v_count := v_count + 1;
      IF MOD(v_count, 1000) = 0 THEN
         OPEN c1;

         FETCH c1 INTO v_parse_total, v_parse_hard;

         CLOSE c1;
         v_hit_rate:=(v_parse_total-v_parse_hard)*100/v_parse_total; 
         if v_hit_rate>p_target_hr then 
            v_end:=v_end*1.1; 
            else
                v_end:=v_end*.9;
            end if; 
            insert into log_table 
                select log_table_seq.nextval ,'v_hit_rate='||v_hit_rate||', v_end='||v_end from dual; 
                
      END IF;
   END LOOP;
END;
/* Formatted on 12-Mar-2009 14:46:52 (QP5 v5.120.811.25008) */
