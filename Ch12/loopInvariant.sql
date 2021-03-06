/* Formatted on 2008/09/29 03:34 (Formatter Plus v4.8.7) */
alter system set plsql_optimize_level=0 scope=memory; 
SET serveroutput on
SET timing on

DECLARE
   v_loop_count    NUMBER := 4000;
   v_counter1      NUMBER;
   v_counter2      NUMBER;
   v_modcounter1   NUMBER;
   v_modcounter2   NUMBER;
   v_sqrt1         NUMBER;
   v_sqrt2         NUMBER;
   v_sum1          NUMBER:=0;
BEGIN
   FOR v_counter1 IN 1 .. 1000
   LOOP
      FOR v_counter2 IN 1 .. 4000
      LOOP
         v_modcounter1 := MOD (v_counter1, 10);
         v_modcounter2 := MOD (v_counter2, 10);
         v_sqrt1 := SQRT (v_counter1);
         v_sqrt2 := SQRT (v_counter2);

         IF v_modcounter1 = 0
         THEN
            IF v_modcounter2 = 0
            THEN
               v_sum1 := v_sum1 + v_sqrt1 + v_sqrt2;
            END IF;
         END IF;
      END LOOP;
   END LOOP;

   DBMS_OUTPUT.put_line (v_sum1);
END;
/

DECLARE
   v_loop_count    NUMBER := 4000;
   v_counter1      NUMBER;
   v_counter2      NUMBER;
   v_modcounter1   NUMBER;
   v_modcounter2   NUMBER;
   v_sqrt1         NUMBER;
   v_sqrt2         NUMBER;
   v_sum1          NUMBER:=0;
BEGIN
   FOR v_counter1 IN 1 .. 1000
   LOOP
      v_modcounter1 := MOD (v_counter1, 10);
      v_sqrt1 := SQRT (v_counter1);
      FOR v_counter2 IN 1 .. 4000
      LOOP
         v_modcounter2 := MOD (v_counter2, 10);
         v_sqrt2 := SQRT (v_counter2);
         IF v_modcounter1 = 0
         THEN
            IF v_modcounter2 = 0
            THEN
               v_sum1 := v_sum1 + v_sqrt1 + v_sqrt2;
            END IF;
         END IF;
      END LOOP;
   END LOOP;

   DBMS_OUTPUT.put_line (v_sum1);
END;
/

