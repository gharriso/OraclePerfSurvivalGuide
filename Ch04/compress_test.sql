/* Formatted on 2008/08/18 15:58 (Formatter Plus v4.8.7) */
DROP TABLE mydummy;
DROP TABLE my_uncompressed;
DROP TABLE my_compressed;
CREATE TABLE mydummy AS SELECT * FROM sh.customers;
INSERT INTO mydummy
   SELECT *
     FROM sh.customers;
INSERT INTO mydummy
   SELECT *
     FROM mydummy;



CREATE TABLE my_uncompressed AS SELECT * FROM mydummy;
CREATE TABLE my_compressed compress AS SELECT * FROM mydummy;
begin
    dbms_stats.gather_schema_stats('OPSG');
end; 
/
     

ALTER SESSION SET tracefile_identifier=compress_test;
ALTER SESSION SET EVENTs '10046 trace name context forever, level 8';
alter system flush buffer_cache; 
 
DECLARE
   TYPE vt IS TABLE OF VARCHAR2 (100)
      INDEX BY BINARY_INTEGER;

   fn   vt;
   LN   vt;
BEGIN
   SELECT /*+ CACHE(M) FULL(M) */
          cust_first_name, cust_last_name
   BULK COLLECT INTO fn, LN
     FROM my_uncompressed M;

   SELECT /*+   FULL(M)*/
          cust_first_name, cust_last_name
   BULK COLLECT INTO fn, LN
     FROM my_uncompressed M;
   execute immediate 'alter system flush buffer_cache';
   
   SELECT /*+ CACHE(M) FULL(M)   */
          cust_first_name, cust_last_name
   BULK COLLECT INTO fn, LN
     FROM my_compressed M;

   SELECT /*+   FULL(M)   */
          cust_first_name, cust_last_name
   BULK COLLECT INTO fn, LN
     FROM my_compressed M;
END;

/

exit; 

