ALTER SESSION  SET plsql_code_type = 'INTERPRETED';
column plsql_code_type format a30
column name format a30



create or replace FUNCTION emc2_pl (g_max_mass PLS_INTEGER)
   RETURN BINARY_DOUBLE
IS
   c   BINARY_DOUBLE := 299792458;                           -- Speed of light
   e   BINARY_DOUBLE;
   v_sum binary_double:=0;
BEGIN
   FOR row IN (    SELECT   ROWNUM m
                     FROM   DUAL
               CONNECT BY   ROWNUM < g_max_mass)
   LOOP
      e := row.m * c * c;
      v_sum:=v_sum+e;
   END LOOP;
   return(v_sum);
END;
/

/* Formatted on 14/12/2008 7:58:35 AM (QP5 v5.120.811.25008) */

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "emc2j"
   AS 
import java.sql.*;
   import oracle.jdbc.driver.*;
   import java.math.*;

   public class emc2j {

    static public double emc2j(int max_mass) throws SQLException  {
    double c   = 299792458;
    double e;
    double sum=0;
    Connection oracleConnection=new OracleDriver().defaultConnection();
    String sql = "SELECT ROWNUM m FROM DUAL "
                + " CONNECT BY   ROWNUM < "+max_mass;

        try {

            Statement s = oracleConnection.createStatement();

            s.setFetchSize(100);
            ResultSet r = s.executeQuery(sql);
            while (r.next()) {
                double m = r.getDouble(1);
                e = m * c * c;
                sum+=e;
            }
            s.close();
        } catch (SQLException x) {
            x.printStackTrace();
        }
        return(sum);
    }
}
.

/
drop procedure emc2j; 
drop function emc2j; 
CREATE OR REPLACE function emc2j (m number) return number

AS
   LANGUAGE JAVA
   NAME 'emc2j.emc2j(int) return int';
/

set serveroutput on

CREATE OR REPLACE PROCEDURE jtestit
IS
   v_start      NUMBER;
   v_max_mass   NUMBER := 100000000;
   v_out        BINARY_DOUBLE;
BEGIN
   v_start := DBMS_UTILITY.get_time ();


   v_out := emc2j (v_max_mass);

   DBMS_OUTPUT.put_line (v_out);
   DBMS_OUTPUT.put_line ('Java: ' || (DBMS_UTILITY.get_time () - v_start));


   v_out := emc2_pl (v_max_mass);

   DBMS_OUTPUT.put_line (v_out);

   DBMS_OUTPUT.put_line ('PLSQL: ' || (DBMS_UTILITY.get_time () - v_start));
END;
/* Formatted on 14/12/2008 8:12:48 AM (QP5 v5.120.811.25008) */
/
select name,plsql_code_type
 from all_plsql_object_settings
where owner=user and name like '%EMC%'; 

BEGIN
   jtestit;
END;
/


ALTER SESSION  SET plsql_code_type = 'NATIVE';
ALTER function emc2_pl COMPILE plsql_code_type=native;

select name,plsql_code_type
 from all_plsql_object_settings
where owner=user and name like '%EMC%'; 

BEGIN
   jtestit;
END;
/

exit
/* Formatted on 13/12/2008 10:56:07 PM (QP5 v5.120.811.25008) */
