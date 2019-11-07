ALTER SESSION  SET plsql_code_type = 'INTERPRETED';
alter session set tracefile_identifier=java_db;
alter session set sql_trace=true; 

column plsql_code_type format a30
column name format a30



CREATE OR REPLACE FUNCTION emc2_pl (g_max_mass PLS_INTEGER)
   RETURN BINARY_DOUBLE
IS
   c       BINARY_DOUBLE := 299792458;                       -- Speed of light
   e       BINARY_DOUBLE;
   v_sum   BINARY_DOUBLE := 0;
   mvals   DBMS_SQL.number_table;
   pids    DBMS_SQL.number_table;

   CURSOR c1
   IS
      SELECT   ROWNUM m, prod_id
        FROM   sh.sales s
       WHERE   ROWNUM < g_max_mass;
BEGIN
   OPEN c1;

   LOOP
      FETCH c1 BULK COLLECT INTO   mvals, pids LIMIT 100;

      EXIT WHEN mvals.COUNT = 0;

      FOR i IN 1 .. mvals.COUNT
      LOOP
         v_sum := v_sum + mvals (i);
      END LOOP;
   END LOOP;

   CLOSE c1;
 

RETURN (v_sum);
END; 
/
 

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
    String sql = "SELECT ROWNUM m, s.* FROM sh.sales s WHERE ROWNUM < "+max_mass;
    System.out.println(sql);

        

            Statement s = oracleConnection.createStatement();

            s.setFetchSize(100);
            ResultSet r = s.executeQuery(sql);
            while (r.next()) {
                double m = r.getDouble(1);
  
                sum+=m;
            }
            s.close();
 
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
   v_max_mass   NUMBER := 1000000;
   v_out        BINARY_DOUBLE;
   v_repeats    NUMBER := 2;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   FOR i IN 1 .. v_repeats
   LOOP
      v_out := emc2j (v_max_mass);
   END LOOP;

   DBMS_OUTPUT.put_line (v_out);
   DBMS_OUTPUT.put_line ('Java: ' || (DBMS_UTILITY.get_time () - v_start));

   FOR i IN 1 .. v_repeats
   LOOP
      v_out := emc2_pl (v_max_mass);
   END LOOP;

   DBMS_OUTPUT.put_line (v_out);

   DBMS_OUTPUT.put_line ('PLSQL: ' || (DBMS_UTILITY.get_time () - v_start));
END;
/* Formatted on 14-Dec-2008 8:31:32 (QP5 v5.120.811.25008) */
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
BEGIN
   jtestit;
END;
/
exit
/* Formatted on 13/12/2008 10:56:07 PM (QP5 v5.120.811.25008) */
