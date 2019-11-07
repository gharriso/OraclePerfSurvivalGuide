SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL group_by_mem
set arraysize 100 
 
ALTER SESSION SET tracefile_identifier=group_by_mem;
ALTER SESSION SET sql_trace=TRUE;
 

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
INSERT INTO customers
   SELECT *
     FROM customers;
COMMIT ;
 

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS'
); 


END;
/
 
ALTER  SYSTEM SET memory_target=0 SCOPE=MEMORY;
ALTER  SYSTEM SET workarea_size_policy=MANUAL SCOPE=MEMORY;

alter system flush buffer_cache; 
alter system flush shared_pool; 
 

set autotrace on 

ALTER SESSION SET "_gby_hash_aggregation_enabled"=true;
alter session set hash_area_size=104857600; 
alter session set sort_area_size=104857600; 

SELECT /* gh1 hash_area_size=100M */ country_id, AVG (cust_credit_limit),stddev(cust_credit_limit) 
    FROM customers
GROUP BY country_id;

alter session set hash_area_size=10240; 
alter session set sort_area_size=10240;

SELECT /* gh1 hash_area_size=10K */ country_id, AVG (cust_credit_limit),stddev(cust_credit_limit) 
    FROM customers
GROUP BY country_id;

ALTER SESSION SET "_gby_hash_aggregation_enabled"=FALSE;

alter system flush buffer_cache; 
 

SELECT /* gh1 hash sort*/ country_id, AVG (cust_credit_limit),stddev(cust_credit_limit) 
    FROM customers
GROUP BY country_id;


set autotrace off

col exec format 9999
col ela format 99999999
col sortime format 99999999 
col mem_mb  format 9999999 
 
SELECT SUBSTR (sql_text, 1, 60), executions AS exec, elapsed_time AS ela,
       active_time AS sortime, ROUND (last_memory_used / 1048576,2) AS mem_mb,
       ROUND (estimated_optimal_size / 1024, 2) opt_kb,POLICY,OPERATION_TYPE,
          optimal_executions
       || '/'
       || onepass_executions
       || '/'
       || multipasses_executions AS "O/1/M"
  FROM v$sql LEFT OUTER JOIN v$sql_workarea USING (sql_id, child_number)
 WHERE sql_text LIKE 'SELECT%gh1 hash%' AND sql_text NOT LIKE '%v$sql%';

 

exit; 

