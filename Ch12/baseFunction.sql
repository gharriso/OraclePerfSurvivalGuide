/* Formatted on 2008/09/21 01:38 (Formatter Plus v4.8.7) */
SET timing on
set serveroutput on 

CREATE OR REPLACE FUNCTION nprimes1 (p_num NUMBER)
   RETURN NUMBER
IS
   i         INT;
   j         INT;
   nprimes   INT;
   isprime   INT;
BEGIN
   i := 2;
   nprimes := 0;

   <<main_loop>>
   WHILE (i < p_num)
   LOOP
      isprime := 1;
      j := 2;

      <<divisor_loop>>
      WHILE (j < i)
      LOOP
         IF (MOD (i, j) = 0)
         THEN
            isprime := 0;
         --EXIT divisor_loop;
         END IF;

         j := j + 1;
      END LOOP;

      IF (isprime = 1)
      THEN
         nprimes := nprimes + 1;
      END IF;

      i := i + 1;
   END LOOP;

   RETURN (p_num);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (nprimes1 (10000));
END;
/
alter function nprimes1 compile plsql_code_type=native;

BEGIN
   DBMS_OUTPUT.put_line (nprimes1 (10000));
END;
/

