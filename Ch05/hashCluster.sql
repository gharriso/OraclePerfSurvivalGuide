 
ALTER SESSION SET tracefile_identifier=hashCluster;

SET pages 1000
SET lines 160
SET echo on
set timing on 

SPOOL hashCluster

BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/
/* Formatted on 2008/08/21 16:06 (Formatter Plus v4.8.7) */
DROP TABLE customers_badhash;
DROP TABLE customers_goodhash;
DROP TABLE customers_nohash;
DROP CLUSTER cust_good_hash_clus;
DROP CLUSTER cust_bad_hash_clus;

/* Formatted on 2008/08/21 16:06 (Formatter Plus v4.8.7) */
CREATE CLUSTER cust_good_hash_clus (cust_id NUMBER)
 HASHKEYS 100000
 SIZE 1000;

/* Formatted on 2008/08/21 16:07 (Formatter Plus v4.8.7) */
CREATE  CLUSTER cust_bad_hash_clus (cust_id NUMBER)
 HASHKEYS 1000
 SIZE 50;

 
/* Formatted on 2008/08/21 16:07 (Formatter Plus v4.8.7) */
CREATE TABLE customers_goodhash CLUSTER cust_good_hash_clus(cust_id)
AS SELECT * FROM sh.customers;

CREATE TABLE customers_badhash CLUSTER cust_bad_hash_clus(cust_id)
AS SELECT * FROM sh.customers;

CREATE TABLE customers_nohash
AS SELECT * FROM sh.customers;


/* Formatted on 2008/08/21 16:07 (Formatter Plus v4.8.7) */
ALTER TABLE customers_nohash ADD PRIMARY KEY (cust_id);
ALTER TABLE customers_goodhash ADD PRIMARY KEY (cust_id);
ALTER TABLE customers_badhash ADD PRIMARY KEY (cust_id);




BEGIN
   DBMS_STATS.gather_schema_stats (ownname => USER);
END;
/

SET autotrace on


select /*+ full(c) */ * from customers_nohash c where cust_id=500; 
select /*+ index(c) */ * from customers_nohash c where cust_id=500;
select * from customers_goodhash where cust_id=500;
select * from customers_goodhash where cust_id=500;
select * from customers_badhash where cust_id=500;

select /*+full(c) */ min(cust_year_of_birth) from customers_nohash c ; 
select /*+full(c) */ min(cust_year_of_birth) from customers_goodhash c ; 
select /*+full(c) */ min(cust_year_of_birth) from customers_badhash c ; 


 
SELECT  tracefile
      FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
      WHERE audsid = USERENV ('SESSIONID'); 
      
exit; 




