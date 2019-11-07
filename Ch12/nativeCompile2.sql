spool nativeCompile2
ALTER SESSION SET  plsql_code_type = 'INTERPRETED';

CREATE OR REPLACE PACKAGE opsg.native_test
IS
   g_max_mass   NUMBER := 100000000;

   PROCEDURE emc23;

   PROCEDURE emc22;

   PROCEDURE emc21;

   PROCEDURE testit;
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY native_test
IS
   g_sum   NUMBER;

   PROCEDURE emc21
   IS
      c   NUMBER := 299792458;                               -- Speed of light
      e   NUMBER;
   BEGIN
      g_sum := 0;

      FOR m IN 1 .. g_max_mass
      LOOP
         e := m * c * c;
      -- g_sum := g_sum + e;
      END LOOP;
   END;

   PROCEDURE emc22
   IS
      c   NUMBER := 299792458;                               -- Speed of light
      e   NUMBER;
   BEGIN
      g_sum := 0;

      FOR m IN 1 .. g_max_mass
      LOOP
         e := m * POWER (c, 2);
      --g_sum := g_sum + e;
      END LOOP;
   END;

   PROCEDURE emc23
   IS
      c       NUMBER := 299792458;                           -- Speed of light
      e       NUMBER;
      v_sql   VARCHAR2 (120);
   BEGIN
      g_sum := 0;

      FOR row IN (    SELECT   ROWNUM m
                        FROM   DUAL
                  CONNECT BY   ROWNUM < g_max_mass)
      LOOP
         e := row.m * c * c; 
      -- g_sum := g_sum + e;
      END LOOP;
   END;

   PROCEDURE testit
   IS
      v_start   NUMBER;
   BEGIN
      v_start := DBMS_UTILITY.get_time ();
      emc21 ();
      DBMS_OUTPUT.put_line (
         'emc21 Time=' || (DBMS_UTILITY.get_time () - v_start));
      --DBMS_OUTPUT.put_line (g_sum);

      v_start := DBMS_UTILITY.get_time ();
      emc22 ();
      DBMS_OUTPUT.put_line (
         'emc22 Time=' || (DBMS_UTILITY.get_time () - v_start));
      --DBMS_OUTPUT.put_line (g_sum);

      g_max_mass := g_max_mass / 10;
      v_start := DBMS_UTILITY.get_time ();
      emc23 ();
      DBMS_OUTPUT.put_line (
         'emc23 Time=' || (DBMS_UTILITY.get_time () - v_start));
   -- DBMS_OUTPUT.put_line (g_sum);
   END;
END;
/

BEGIN
   native_test.testit ();
END;
/

prompt "interpreted"
set serveroutput on

BEGIN
   native_test.testit ();
END;
/

ALTER SESSION  SET plsql_code_type = 'NATIVE';
ALTER PACKAGE native_test COMPILE plsql_code_type=native;
set serveroutput off

BEGIN
   native_test.testit ();
END;
/

prompt "compiled"
set serveroutput on

BEGIN
   native_test.testit ();
END;
/

/* Formatted on 12/12/2008 9:40:08 PM (QP5 v5.120.811.25008) */
