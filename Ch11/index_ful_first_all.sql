/* Formatted on 2008/11/25 14:48 (Formatter Plus v4.8.7) */
SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL index_ful_first_all
alter session set tracefile_identifier=index_vs_full;
alter session set sql_trace=true; 

/* Formatted on 2008/11/25 14:52 (Formatter Plus v4.8.7) */
DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;
INSERT INTO customers
   SELECT *
     FROM customers;
INSERT INTO customers
   SELECT *
     FROM customers;
INSERT INTO customers
   SELECT *
     FROM customers;


CREATE INDEX cust_namedob_i ON customers (cust_last_name, cust_first_name, cust_year_of_birth);

PROMPT "FTS first rows"
alter system flush buffer_cache; 

DECLARE
   CURSOR c1
   IS
      SELECT   * /* FTS first rows*/
          FROM customers
      ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;

   r1   c1%ROWTYPE;
BEGIN
   OPEN c1;

   FETCH c1
    INTO r1;

   CLOSE c1;
END;
/

PROMPT "FTS all rows"
alter system flush buffer_cache; 

DECLARE
   CURSOR c1
   IS
      SELECT   * /* FTS allrows*/
          FROM customers
      ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;

   r1   c1%ROWTYPE;
BEGIN
   FOR r1 IN c1
   LOOP
      NULL;
   END LOOP;
END;
/
alter system flush buffer_cache; 
PROMPT "index first rows"
DECLARE
   CURSOR c1
   IS
      SELECT   /*+  INDEX(c) */ /* index first rows*/
               *
          FROM customers c
      ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;

   r1   c1%ROWTYPE;
BEGIN
   OPEN c1;

   FETCH c1
    INTO r1;

   CLOSE c1;
END;
/

alter system flush buffer_cache; 
PROMPT "index all rows"

DECLARE
   CURSOR c1
   IS
      SELECT   /*+  INDEX(c) */ /* index all rows*/
               *
          FROM customers c
      ORDER BY cust_last_name, cust_first_name, cust_year_of_birth;

   r1   c1%ROWTYPE;
BEGIN
   FOR r1 IN c1
   LOOP
      NULL;
   END LOOP;
END;
/

exit; 
