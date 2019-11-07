/* Formatted on 2008/10/07 10:13 (Formatter Plus v4.8.7) */
ALTER SESSION SET plsql_optimize_level=2;
ALTER SESSION SET plsql_optimize_level=3;


/* Formatted on 2008/10/07 10:25 (Formatter Plus v4.8.7) */
CREATE OR REPLACE PACKAGE primes
AS
   FUNCTION pprimes (p_in NUMBER)
      RETURN NUMBER;
END;
/

/* Formatted on 2008/10/07 10:25 (Formatter Plus v4.8.7) */
CREATE OR REPLACE PACKAGE BODY primes
AS
   FUNCTION pprimes (p_in NUMBER)
      RETURN NUMBER
   IS
      nprimes   NUMBER := 0;
   BEGIN
      FOR i IN 2 .. p_in - 1
      LOOP
         IF MOD (p_in, i) = 0
         THEN
            nprimes := nprimes + 1;
         END IF;
      END LOOP;

      RETURN (nprimes);
   END;
END;                                                       -- Function NPRIMES
.

/

create or replace FUNCTION pprimes (p_in NUMBER)
   RETURN NUMBER
IS
   nprimes   NUMBER := 0;
BEGIN
   FOR i IN 2 .. p_in - 1
   LOOP
      IF MOD (p_in, i) = 0
      THEN
         nprimes := nprimes + 1;
      END IF;
   END LOOP;

   RETURN (nprimes);
END; 
/
CREATE OR REPLACE FUNCTION si_primes (p_in simple_integer)
   RETURN NUMBER
IS
   nprimes   simple_integer := 0;
BEGIN
   FOR i IN 2 .. p_in - 1
   LOOP
      IF MOD (p_in, i) = 0
      THEN
         nprimes := nprimes + 1;
      END IF;
   END LOOP;

   RETURN (nprimes);
END;                                                       -- Function NPRIMES
.

/
CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "cprime"
AS import java.sql.*;
import oracle.jdbc.driver.*;
import java.math.*;

public class cprime {

  static public int nprimes(int in_num) {
    int i,j;
    int nprimes=0;
    for (i=2;i<in_num;i++)
      {
        if (in_num%i==0)
        {
          nprimes++;
        }
      }
      return(nprimes);
   }
}
/

CREATE OR REPLACE FUNCTION j_nprimes (p_in NUMBER)
   RETURN NUMBER
AS
   LANGUAGE JAVA
   NAME 'cprime.nprimes(int) return int';
/

SET timing on
SET serveroutput on

alter function j_nprimes compile plsql_code_type=interpreted;
alter function pprimes compile plsql_code_type=interpreted;
alter function si_primes compile plsql_code_type=interpreted;

BEGIN
   DBMS_OUTPUT.put_line ('Java:' || j_nprimes (10000000));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('PLSQL:' || pprimes (10000000));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('PLSQL:' || si_primes (10000000));
END;
/

alter function j_nprimes compile plsql_code_type=native;
alter function pprimes compile plsql_code_type=native;
alter function si_primes compile plsql_code_type=native;
alter package primes compile plsql_code_type=native;

prompt compiled 

BEGIN
   DBMS_OUTPUT.put_line ('Java:' || j_nprimes (10000000));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('PLSQL:' || pprimes (10000000));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('PLSQL:' || si_primes (10000000));
END;
/
BEGIN
   DBMS_OUTPUT.put_line ('Package PLSQL:' || primes.pprimes (10000000));
END;
/


EXIT;

