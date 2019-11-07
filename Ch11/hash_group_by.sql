SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL group_by_hash
set arraysize 100 
 
ALTER SESSION SET tracefile_identifier=group_by_hash;
ALTER SESSION SET sql_trace=TRUE;
 
 
DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;
INSERT INTO customers
   SELECT *
     FROM customers;
INSERT INTO customers
   SELECT *
     FROM customers;


BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS'
); 


END;
/



alter system flush buffer_cache; 
alter system flush shared_pool; 
ALTER SESSION SET "_gby_hash_aggregation_enabled"=TRUE;

set autotrace on 

SELECT /* gh1 gby gby_hash_aggregation_enabled */ country_id, AVG (cust_credit_limit)
    FROM customers
GROUP BY country_id;

alter system flush buffer_cache; 


SELECT /* gh1 gby+sort gby_hash_aggregation_enabled */ country_id, AVG (cust_credit_limit)
    FROM customers
GROUP BY country_id
ORDER BY country_id; 

set autotrace off

ALTER SESSION SET "_gby_hash_aggregation_enabled"=FALSE;

alter system flush buffer_cache; 

set autotrace on 

SELECT /* gh1 gby hash_aggregation_disabled */ country_id, AVG (cust_credit_limit)
    FROM customers
GROUP BY country_id;

set autotrace off 
 
CREATE  INDEX customers_city_limit_i ON customers( country_id, cust_credit_limit);

ALTER  SESSION SET "_gby_hash_aggregation_enabled"=TRUE;

set autotrace on

SELECT /* gh1 gby index plan  */ country_id, AVG (cust_credit_limit)
    FROM customers
GROUP BY country_id;

set autotrace off

col exec format 9999
col ela format 99999999
col sortime format 99999999 
col mem_mb  format 9999999 
SELECT SUBSTR (sql_text, 1, 60),executions as exec,elapsed_time as ela,active_time as sortime, 
    round(last_memory_used/1048576) as mem_mb
  FROM v$sql LEFT OUTER JOIN v$sql_workarea USING (sql_id, child_number)
 WHERE sql_text LIKE 'SELECT%gh1 gby%' AND sql_text NOT LIKE '%v$sql%'; 
 

exit; 

