ALTER SESSION SET plsql_optimize_level=2;

CREATE OR REPLACE PACKAGE datatype_test
IS
   PROCEDURE emc2a;

   PROCEDURE testit;
END;
/

CREATE OR REPLACE PACKAGE BODY datatype_test
IS
   g_max_mass   NUMBER := 100;

   PROCEDURE emc2a
   IS
      c   NUMBER := 299792458;                               -- Speed of light
      e   NUMBER;
   BEGIN
      FOR m IN 1 .. g_max_mass
      LOOP
         e := m * c * c;
      -- g_sum := g_sum + e;
      END LOOP;
   END;

   PROCEDURE emc2b
   IS
      c   PLS_INTEGER := 299792458;                          -- Speed of light
      e   PLS_INTEGER;
   BEGIN
      FOR m IN 1 .. g_max_mass
      LOOP
         e := m * c * c;
      END LOOP;
   END;


   PROCEDURE testit
   IS
      v_start_time   NUMBER;
      v_loops        NUMBER := 100;
   BEGIN
      v_start_time := DBMS_UTILITY.get_time ();

      FOR i IN 1 .. v_loops
      LOOP
         emc2a ();
      END LOOP;

      DBMS_OUTPUT.put_line (
         'emc2a=' || (DBMS_UTILITY.get_time () - v_start_time));

      v_start_time := DBMS_UTILITY.get_time ();

      FOR i IN 1 .. v_loops
      LOOP
         emc2b ();
      END LOOP;

      DBMS_OUTPUT.put_line (
         'emc2b=' || (DBMS_UTILITY.get_time () - v_start_time));
   END;
END;
/

set serveroutput on

BEGIN
   datatype_test.testit ();
END;
/* Formatted on 13-Dec-2008 13:01:51 (QP5 v5.120.811.25008) */
