CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "jav_si"
   AS 
   public class jav_si {
       static public int jav_si(int iterations,int max_in_val)  {
        int sq_val =0;
        int in_val=0;
        int i,j;
        for (j=1;j<=iterations;j++) {
            in_val=1;
            while (in_val<max_in_val) {
                sq_val=in_val*in_val+in_val;
                in_val=in_val+1; 
            }
        }
        return(0);
    }
}
.
/
CREATE OR REPLACE function jav_si (iter number,max_in_val number) return number

AS
   LANGUAGE JAVA
   NAME 'jav_si.jav_si(int,int) return int';
/

CREATE OR REPLACE PACKAGE si_demo
AS
   PROCEDURE test_si;

   PROCEDURE test_pls;

   PROCEDURE test_num;

   PROCEDURE test;
END;
/

CREATE OR REPLACE PACKAGE BODY si_demo
AS
   g_max_input_value   CONSTANT PLS_INTEGER := 10000;
   g_iterations        NUMBER := 10000;



   PROCEDURE test_si
   IS
      sq_val      SIMPLE_INTEGER := 0;
      in_val      SIMPLE_INTEGER := 0;
      starttime   NUMBER;
   BEGIN
      starttime := DBMS_UTILITY.get_time;

      FOR j IN 1 .. g_iterations
      LOOP
         in_val := 1;

         WHILE in_val < g_max_input_value
         LOOP
            sq_val := in_val * in_val + in_val;
            in_val := in_val + 1;
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line ('SIMPLE_INTEGER elapsed time(seconds):'
                            || TO_CHAR ( (DBMS_UTILITY.get_time - starttime)
                                        / 100, '990.90'));
   END;


   PROCEDURE test_pls
   IS
      sq_val      PLS_INTEGER := 0;
      in_val      PLS_INTEGER := 0;
      starttime   NUMBER;
   BEGIN
      starttime := DBMS_UTILITY.get_time;

      FOR j IN 1 .. g_iterations
      LOOP
         in_val := 1;

         WHILE in_val < g_max_input_value
         LOOP
            sq_val := in_val * in_val + in_val;
            in_val := in_val + 1;
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line ('PLS_INTEGER elapsed time(seconds):'
                            || TO_CHAR ( (DBMS_UTILITY.get_time - starttime)
                                        / 100, '990.90'));
   END;

   PROCEDURE test_num
   IS
      sq_val      NUMBER := 0;
      in_val      NUMBER := 0;
      starttime   NUMBER;
   BEGIN
      starttime := DBMS_UTILITY.get_time;

      FOR j IN 1 .. g_iterations
      LOOP
         in_val := 1;

         WHILE in_val < g_max_input_value
         LOOP
            sq_val := in_val * in_val + in_val;
            in_val := in_val + 1;
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line ('NUMBER elapsed time(seconds):'
                            || TO_CHAR ( (DBMS_UTILITY.get_time - starttime)
                                        / 100, '990.90'));
   END;

   PROCEDURE test
   IS
      chk_sum number:=0; 
      v_start number;
   BEGIN
      si_demo.test_si;

      si_demo.test_pls;
      si_demo.test_num;
      v_start:=dbms_utility.get_time(); 
      chk_sum:=jav_si(g_max_input_value, g_iterations ); 
        DBMS_OUTPUT.put_line ('Java elapsed time(seconds):'
                            || TO_CHAR ( (DBMS_UTILITY.get_time - v_start)
                                        / 100, '990.90'));
   END;
END;
/


set serveroutput on

BEGIN
   si_demo.test;
END;
/

ALTER PACKAGE si_demo COMPILE plsql_code_type=native;

BEGIN
   si_demo.test;
END;
/

exit; 
