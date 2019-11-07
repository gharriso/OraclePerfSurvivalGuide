 
ALTER SESSION SET tracefile_identifier=sortedHash;

SET pages 1000
SET lines 160
SET echo on
set timing on 

SPOOL sortedHash
rem 
rem object creation here
rem


BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE
                                     );
END;
/



SET autotrace on
rem
rem Queries, etc, here 
rem

 
DROP TABLE g_SORTED_HASH;
DROP CLUSTER ghordercluster including tables ;
DROP TABLE g_UNSORTED_HASH;
DROP CLUSTER ghnoordercluster including tables ;


CREATE CLUSTER ghOrderCluster ( 
   customer_id NUMBER(8), 
   order_date  DATE SORT ) 
  HASHKEYS 200 HASH IS customer_id
  SIZE 20000 ; 


CREATE TABLE g_SORTED_HASH ( 
   customer_id     NUMBER(8), 
   order_date       DATE   SORT, 
   order_id         number(8), 
   order_quantity number(10) ) 
  CLUSTER ghOrderCluster ( 
   customer_id,order_date );
   
CREATE CLUSTER ghNoOrderCluster ( 
   customer_id NUMBER(8) ) 
  HASHKEYS 200 HASH IS customer_id
  SIZE 20000 ; 


CREATE TABLE g_UNSORTED_HASH ( 
   customer_id     NUMBER(8), 
   order_date       DATE   , 
   order_id         number(8), 
   order_quantity number(10) ) 
  CLUSTER ghNoOrderCluster ( 
   customer_id  );   

 
DECLARE
   TYPE nt IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE dt IS TABLE OF DATE
      INDEX BY BINARY_INTEGER;

   cid   nt;
   OID   nt;
   od    dt;
   oq    nt;
BEGIN
   FOR i IN 1 .. 200
   LOOP
      FOR j IN 1 .. 5000
      LOOP
         cid (j) := i;
         OID (j) := i * 100000 + j;
         od (j) := SYSDATE - DBMS_RANDOM.VALUE (1, 1000);
         oq (j) := DBMS_RANDOM.VALUE (1, 100000);
      END LOOP;

      FORALL j IN 1 .. cid.COUNT
         INSERT INTO g_SORTED_HASH
                     (customer_id, order_date, order_id, order_quantity
                     )
              VALUES (cid (j), OD (j), oid (j), oq (j)
                     );
      FORALL j IN 1 .. cid.COUNT
         INSERT INTO g_UNSORTED_HASH
                     (customer_id, order_date, order_id, order_quantity
                     )
              VALUES (cid (j), OD (j), oid (j), oq (j)
                     );
      COMMIT;
   END LOOP;
END;
/

COMMIT ;
BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER,tabname=>'g_SORTED_HASH');
   DBMS_STATS.gather_table_stats (ownname => USER,tabname=>'g_UNSORTED_HASH');
END;
/
alter system flush buffer_cache; 

set autotrace traceonly

SELECT /* OPSG */ *
  FROM g_SORTED_HASH
 WHERE customer_id = 50;

alter system flush buffer_cache; 
 
 SELECT /* OPSG */ *
  FROM g_SORTED_HASH
 WHERE customer_id = 50 order by order_date; 
 
alter system flush buffer_cache; 
 
 SELECT /* OPSG */ *
  FROM g_UNSORTED_HASH
 WHERE customer_id = 50;

alter system flush buffer_cache; 
 
 SELECT /* OPSG */ *
  FROM g_UNSORTED_HASH
 WHERE customer_id = 50 order by order_date; 
 
 alter system flush buffer_cache;
 
 select /* OPSG */ sum(order_quantity) from g_UNSORTED_HASH;
 select /* OPSG */ sum(order_quantity) from g_SORTED_HASH;

alter system flush buffer_cache; 

set autotrace off 
  
SELECT  tracefile
      FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
      WHERE audsid = USERENV ('SESSIONID'); 
      
exit; 




