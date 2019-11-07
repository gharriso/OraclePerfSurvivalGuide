spool nativeCompile3
ALTER SESSION SET  plsql_code_type = 'INTERPRETED';

CREATE OR REPLACE PACKAGE native_test3
IS
   g_max   NUMBER := 10000000;

   PROCEDURE sqrts;
   procedure testit; 
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY native_test3
IS
   PROCEDURE sqrts
   IS
      v_sqrt_val   NUMBER;
   BEGIN
      FOR i IN 1 .. g_max
      LOOP
         v_sqrt_val := SQRT (i);
      END LOOP;
   END;

   PROCEDURE testit
   IS
      v_start   NUMBER;
   BEGIN
      v_start := DBMS_UTILITY.get_time ();
      sqrts ();
      DBMS_OUTPUT.put_line (
         'sqrts Time=' || (DBMS_UTILITY.get_time () - v_start));
   END;
END;
/

BEGIN
   native_test3.testit ();
END;
/

prompt "interpreted"
set serveroutput on

BEGIN
   native_test3.testit ();
END;
/

ALTER SESSION  SET plsql_code_type = 'NATIVE';
ALTER PACKAGE native_test3 COMPILE plsql_code_type=native;
set serveroutput off

BEGIN
   native_test3.testit();
END;
/

prompt "compiled"
set serveroutput on

BEGIN
   native_test3.testit();
END;
/

exit; 
