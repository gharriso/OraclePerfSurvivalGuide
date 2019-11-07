/* Formatted on 2008/08/20 10:24 (Formatter Plus v4.8.7) */
DROP TABLE customers2;
CREATE TABLE customers2 AS SELECT * FROM sh.customers;

CREATE INDEX cust_i_last_first_uncom ON customers2(cust_last_name,cust_first_name,cust_year_of_birth);


BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS2');
END;
/

SELECT *
  FROM user_indexes
 WHERE table_name = 'CUSTOMERS2';
DROP INDEX cust_i_last_first_uncom;

CREATE INDEX cust_i_last_first_compr ON customers2(cust_last_name,cust_first_name,cust_year_of_birth) COMPRESS 2;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS2');
END;
/

SELECT *
  FROM user_indexes
 WHERE table_name = 'CUSTOMERS2';

