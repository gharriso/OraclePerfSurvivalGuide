SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL count

ALTER SESSION SET tracefile_identifier=count;
ALTER SESSION SET sql_trace=TRUE;

DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;
alter table customers add constraint customers_pk primary key (cust_id); 
     
BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS'
); 


END;
/

set autotrace on 

SELECT COUNT (*) FROM customers;
SELECT COUNT (1) FROM customers;
SELECT COUNT (cust_id) FROM customers;

exit; 

     


