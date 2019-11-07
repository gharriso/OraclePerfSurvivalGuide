/* Formatted on 2008/09/21 00:43 (Formatter Plus v4.8.7) */
SPOOL baselines1

SET lines 120
SET pages 1000
SET echo on
SET long 32758
SET serveroutput on

BEGIN
   FOR r IN (SELECT plan_name
               FROM dba_sql_plan_baselines
              WHERE creator = 'OPSG')
   LOOP
      DBMS_OUTPUT.put_line
                   (dbms_spm.drop_sql_plan_baseline (plan_name      => r.plan_name)
                   );
   END LOOP;
END;
/

ALTER  SYSTEM FLUSH SHARED_POOL;



DROP TABLE customers;
DROP TABLE countries;
CREATE TABLE customers AS SELECT * FROM sh.customers;
CREATE TABLE countries AS SELECT * FROM sh.countries;

CREATE INDEX cust_year_of_birth_idx ON customers(cust_year_of_birth);
CREATE INDEX cust_city_idx ON customers(cust_city_id);
CREATE INDEX cust_country_idx ON customers(country_id);
CREATE INDEX country_name_idx ON  countries(country_name);
CREATE INDEX cust_marital_year_idx ON customers(cust_marital_status, cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'COUNTRIES');
END;
/

SET autotrace on

CREATE OR REPLACE OUTLINE baselined_outline FOR CATEGORY outlines2 ON
SELECT /*GHBaseLines2*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;


SELECT *
  FROM dba_sql_plan_baselines;

COLUMN sql_handle format a16
COLUMN plan_name format a16

COLUMN accepted format a8
COLUMN cost format 99999
COLUMN fixed format a5

SELECT sql_handle, plan_name, origin, accepted, FIXED, optimizer_cost AS COST
  FROM dba_sql_plan_baselines
 WHERE sql_text LIKE 'SELECT /*GHBaseLines2*/%';

SET autotrace on

SELECT /*GHBaseLines2*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;

SET autotrace off

VAR v_sql_handle varchar2(100)

BEGIN
   SELECT sql_handle
     INTO :v_sql_handle
     FROM dba_sql_plan_baselines
    WHERE sql_text LIKE 'SELECT /*GHBaseLines2*/%';
END;
/

SELECT *
  FROM TABLE (DBMS_XPLAN.display_sql_plan_baseline (:v_sql_handle,
                                                    NULL,
                                                    'BASIC'
                                                   )
             );

