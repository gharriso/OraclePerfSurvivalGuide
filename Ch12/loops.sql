alter session set plsql_optimize_level=2;

CREATE OR REPLACE FUNCTION nprimesBad (p_num NUMBER)
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

   RETURN (nprimes);
END;
/

CREATE OR REPLACE FUNCTION nprimesGood (p_num NUMBER)
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
            EXIT divisor_loop;
         END IF;

         j := j + 1;
      END LOOP;

      IF (isprime = 1)
      THEN
         nprimes := nprimes + 1;
      END IF;

      i := i + 1;
   END LOOP;

   RETURN (nprimes);
END;
/
set echo on 
set timing on 
spool loops

select 'Poor loop',nprimesbad(10000) from dual;
select 'Good loop',nprimesgood(10000) from dual; 

exit; 
