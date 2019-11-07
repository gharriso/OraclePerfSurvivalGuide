alter session set plsql_optimize_level=2; 

create or replace PACKAGE  inline_test
IS
   PROCEDURE emc2a;

   PROCEDURE testit;

   PROCEDURE emc2b;
END;
/
create or replace PACKAGE BODY inline_test
IS
   g_max_mass   NUMBER := 100000000;

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

   FUNCTION mass_to_energy (p_mass NUMBER)
      RETURN NUMBER
   IS
      c   NUMBER := 299792458;                               -- Speed of light
      e   NUMBER;
   BEGIN
      e := p_mass * c * c;
      RETURN (e);
   END;

   PROCEDURE emc2b
   IS
      e   NUMBER;
   BEGIN
      FOR m IN 1 .. g_max_mass
      LOOP
         e := mass_to_energy (m);
      END LOOP;
   END;

   PROCEDURE emc2c
   IS
      e   NUMBER;
   BEGIN
      FOR m IN 1 .. g_max_mass
      LOOP
         PRAGMA INLINE (mass_to_energy, 'YES');
         e := mass_to_energy (m);
      END LOOP;
   END;

   PROCEDURE testit
   IS
      v_start_time   NUMBER;
   BEGIN
      v_start_time := DBMS_UTILITY.get_time ();
      emc2a ();
      DBMS_OUTPUT.put_line (
         'emc2a=' || (DBMS_UTILITY.get_time () - v_start_time));

      v_start_time := DBMS_UTILITY.get_time ();
      emc2b ();
      DBMS_OUTPUT.put_line (
         'emc2b=' || (DBMS_UTILITY.get_time () - v_start_time));

      v_start_time := DBMS_UTILITY.get_time ();
      emc2c ();
      DBMS_OUTPUT.put_line (
         'emc2c=' || (DBMS_UTILITY.get_time () - v_start_time));
   END;
END;
/
set serveroutput on 

begin 
    inline_test.testit();
end; 

