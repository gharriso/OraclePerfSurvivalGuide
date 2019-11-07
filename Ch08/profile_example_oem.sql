/* Formatted on 2008/09/11 22:41 (Formatter Plus v4.8.7) */
SPOOL profile_example_oem

SET lines 120
SET pages 1000
SET long 32768

DROP TABLE customers;
DROP TABLE countries;
CREATE TABLE customers AS SELECT * FROM sh.customers;
CREATE TABLE countries AS SELECT * FROM sh.countries;

COLUMN ol_name format a20
COLUMN hint_text format a40

CREATE INDEX cust_year_of_birth_idx ON customers(cust_year_of_birth);
CREATE INDEX cust_city_idx ON customers(cust_city_id);
CREATE INDEX cust_country_idx ON customers(country_id);
create index country_name_idx on  COUNTRIES(country_name);
create index cust_marital_year_idx on CUSTOMERS(cust_marital_status, cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS',
                                  method_opt      => 'FOR ALL  COLUMNS SIZE 1'
                                 );
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'COUNTRIES',
                                  method_opt      => 'FOR ALL  COLUMNS SIZE 1'
                                 );
END;
/

REM select column_name,num_distinct,density,low_value,high_value from user_tab_col_statistics where table_name='CUSTOMERS';

SET autotrace on

set echo on 
/* Formatted on 2008/09/12 11:41 (Formatter Plus v4.8.7) */
BEGIN
   FOR i IN 1 .. 5000
   LOOP
      FOR r IN (SELECT /* OPSG Profile example */ *
                  FROM customers JOIN countries USING (country_id)
                 WHERE cust_marital_status = 'Mar-AF'
                   AND country_name = 'United States of America'
                   AND cust_year_of_birth > 1960)
      LOOP
         NULL;
      END LOOP;

      DBMS_LOCK.sleep (1);
   END LOOP;
END;
/
SET autotrace off


