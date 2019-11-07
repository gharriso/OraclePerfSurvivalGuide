set timing on 
set echo on 

CREATE OR REPLACE PROCEDURE sum_of_primes (p_limit NUMBER)
IS
   n_primes   NUMBER;
BEGIN
   FOR i IN 1 .. p_limit
   LOOP
      n_primes := nprimes1 (i);
      DBMS_OUTPUT.put_line (n_primes || ' prime numbers under ' || i);
   END LOOP;
END;
/

EXEC sum_of_primes(500);

alter system set PLSQL_OPTIMIZE_LEVEL = 3;

EXEC sum_of_primes(500);


