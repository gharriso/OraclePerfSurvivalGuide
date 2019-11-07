ALTER SESSION  SET plsql_code_type = 'INTERPRETED';
column plsql_code_type format a30
column name format a30



CREATE OR REPLACE FUNCTION emc2_pl (m BINARY_DOUBLE)
   RETURN NUMBER
IS
   c   BINARY_DOUBLE := 299792458;                           -- Speed of light
   e   BINARY_DOUBLE;
BEGIN
   e := m * c * c;
   RETURN (e);
END;
/

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "emc2"
   AS public class emc2 {

  static public double emc2(double m) {
    double c=299792458; 
    double e; 
    e=m*c*c; 
    return(e);
   }
}
.

/

CREATE OR REPLACE FUNCTION emc2_j (m BINARY_DOUBLE)
   RETURN NUMBER
AS
   LANGUAGE JAVA
   NAME 'emc2.emc2(double) return double';
/

set serveroutput on

CREATE OR REPLACE PROCEDURE testit
IS
   v_start      NUMBER;
   v_max_mass   NUMBER := 1000000;
   v_out        BINARY_DOUBLE;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   FOR i IN 1 .. v_max_mass
   LOOP
      v_out := emc2_j (i);
   END LOOP;

   DBMS_OUTPUT.put_line ('Java: ' || (DBMS_UTILITY.get_time () - v_start));

   FOR i IN 1 .. v_max_mass
   LOOP
      v_out := emc2_pl (i);
   END LOOP;

   DBMS_OUTPUT.put_line ('PLSQL: ' || (DBMS_UTILITY.get_time () - v_start));
END;
/
select name,plsql_code_type
 from all_plsql_object_settings
where owner=user and name like '%EMC%'; 

BEGIN
   testit;
END;
/


ALTER SESSION  SET plsql_code_type = 'NATIVE';
ALTER function emc2_pl COMPILE plsql_code_type=native;

select name,plsql_code_type
 from all_plsql_object_settings
where owner=user and name like '%EMC%'; 

BEGIN
   testit;
END;
/

exit
/* Formatted on 13/12/2008 10:56:07 PM (QP5 v5.120.811.25008) */
