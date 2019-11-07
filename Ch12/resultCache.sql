/* Formatted on 2008/09/21 01:38 (Formatter Plus v4.8.7) */
SET timing on
set serveroutput on 
alter session set tracefile_identifier=functionCache;
alter session set sql_trace true; 

drop function time_sales;
drop function nprimes1; 
begin 
    DBMS_RESULT_CACHE.flush;
end;
/

CREATE OR REPLACE FUNCTION time_sales (p_days NUMBER)
   RETURN NUMBER
IS
   v_amount_sold   NUMBER;
BEGIN
   SELECT SUM (amount_sold)
     INTO v_amount_sold
     FROM sh.sales
    WHERE time_id>sysdate-numtodsinterval(p_days,'DAY'); 
    return(v_amount_sold); 
END;
/

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

   RETURN (nprimes);
END;
/
set echo on 

CREATE OR REPLACE FUNCTION time_sales_rc (p_days NUMBER)
   RETURN NUMBER
   RESULT_CACHE RELIES_ON(sh.sales) IS

   v_amount_sold   NUMBER;
BEGIN
   SELECT SUM (amount_sold)
     INTO v_amount_sold
     FROM sh.sales
    WHERE time_id>sysdate-numtodsinterval(p_days,'DAY'); 
    return(v_amount_sold); 
END;
/

CREATE OR REPLACE FUNCTION nprimes1_rc (p_num NUMBER)
   RETURN NUMBER
   result_cache 
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
col name format a30
col plsql_code_type format a30

select name,plsql_code_type
 from all_plsql_object_settings
where owner=user; 

/* Formatted on 2008/09/24 05:55 (Formatter Plus v4.8.7) */
DECLARE
   OUT   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('No function cache');

   FOR i IN 1 .. 1000
   LOOP
      OUT := nprimes1 (ROUND (DBMS_RANDOM.VALUE (100, 500)));
   END LOOP;
END;
/
DECLARE
   OUT   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('function cache');

   FOR i IN 1 .. 1000
   LOOP
      OUT := nprimes1_rc (ROUND (DBMS_RANDOM.VALUE (100, 500)));
   END LOOP;
END;
/
DECLARE
   OUT   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('No function cache');

   FOR i IN 1 .. 100
   LOOP
      OUT := time_sales  (ROUND (DBMS_RANDOM.VALUE (1, 30)));
   END LOOP;
END;
/
DECLARE
   OUT   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('function cache');

   FOR i IN 1 .. 100
   LOOP
      OUT := time_sales_rc (ROUND (DBMS_RANDOM.VALUE (1, 30)));
   END LOOP;
END;
/
