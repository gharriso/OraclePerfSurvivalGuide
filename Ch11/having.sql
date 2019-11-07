SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL having
set arraysize 100 
 
ALTER SESSION SET tracefile_identifier=having;
ALTER SESSION SET sql_trace=TRUE;
 
 
DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;
INSERT INTO customers
   SELECT *
     FROM customers;
INSERT INTO customers
   SELECT *
     FROM customers;

 
DROP TABLE countries;
CREATE TABLE countries AS SELECT * FROM sh.countries;


BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS'); 
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'COUNTRIES'); 

END;
/

set autotrace on  
 
SELECT /* gh1 having count */ country_name, AVG (cust_credit_limit), COUNT (*)
    FROM customers join countries using (country_id) 
GROUP BY country_name 
  HAVING COUNT (*) > 10000
 /

alter system flush shared_pool; 
alter system flush buffer_cache;  
 
SELECT /* gh1 having country_name */ country_name, AVG (cust_credit_limit),
          COUNT (*)
    FROM customers JOIN countries USING (country_id)
GROUP BY country_name
  HAVING country_name IN ('United States of America', 'New Zealand');

alter system flush buffer_cache; 
 
SELECT /* gh1 where country_name */ country_name, AVG (cust_credit_limit),
          COUNT (*)
    FROM customers JOIN countries USING (country_id)
   WHERE country_name IN ('United States of America', 'New Zealand')
GROUP BY country_name;

set autotrace off

col exec format 9999
col ela format     99999999
col sortime format 99999999 
col mem_mb  format 9999999 
col iotime format  99999999
col cputime format 99999999

SELECT SUBSTR (sql_text, 7, 25), operation_type, executions AS exec,
       elapsed_time AS ela, active_time AS sortime,
       user_io_wait_time AS iotime, cpu_time AS cputime,
       ROUND (last_memory_used / 1048576) AS mem_mb
  FROM v$sql LEFT OUTER JOIN v$sql_workarea USING (sql_id, child_number)
 WHERE sql_text LIKE 'SELECT% gh1 %' AND sql_text NOT LIKE '%v$sql%';


EXIT; 

