/* Formatted on 2008/09/15 15:16 (Formatter Plus v4.8.7) */
SPOOL baselines1

SET lines 120
SET pages 1000
SET echo on
SET long 32758
SET serveroutput on

BEGIN
   FOR r IN (SELECT sql_handle
               FROM dba_sql_plan_baselines
              WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%')
   LOOP
      DBMS_OUTPUT.put_line
                 (dbms_spm.drop_sql_plan_baseline (sql_handle      => r.sql_handle)
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

SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;

SET autotrace off

/
/
/
/
/

EXPLAIN PLAN FOR 
SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;
   
select * from TABLE(dbms_xplan.display(null,null,'BASIC +NOTE')); 

SELECT sql_id, sql_text
  FROM v$sql
 WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%';
VAR v_sql_id varchar2(20);


BEGIN
   SELECT sql_id
     INTO :v_sql_id
     FROM v$sql
    WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%';
END;
/

DECLARE
   v_sql_id       v$sql.sql_id%TYPE;
   v_plan_count   NUMBER;
BEGIN
   SELECT sql_id
     INTO v_sql_id
     FROM v$sql
    WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%';

   v_plan_count := dbms_spm.load_plans_from_cursor_cache 
                    (sql_id => v_sql_id, fixed=>'YES');
   DBMS_OUTPUT.put_line (v_plan_count || ' plans loaded');
END;
/

COLUMN sql_handle format a16
column plan_name format a16
 
COLUMN accepted format a8
COLUMN cost format 99999

SELECT sql_handle, plan_name, origin,  accepted, 
       optimizer_cost AS COST
  FROM dba_sql_plan_baselines
 WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%';

SET autotrace on

SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;

SET autotrace off


CREATE INDEX cust_country_index_dob_ix ON 
    customers(country_id,cust_income_level,cust_year_of_birth);

SET autotrace on

SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;

SET autotrace off
EXPLAIN PLAN FOR 
SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;
   
select * from TABLE(dbms_xplan.display(null,null,'BASIC +NOTE')); 


SELECT sql_handle, plan_name,origin,accepted, 
        optimizer_cost AS COST
  FROM dba_sql_plan_baselines
 WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%';

VAR v_sql_handle varchar2(60);
VAR v_report clob;


BEGIN
   SELECT sql_handle
     INTO :v_sql_handle
     FROM dba_sql_plan_baselines
    WHERE sql_text LIKE 'SELECT /*GHBaseLines1*/%' AND accepted = 'NO';
END;
/

SELECT *
  FROM TABLE (DBMS_XPLAN.display_sql_plan_baseline
     (:v_sql_handle, NULL, 'BASIC' ) );

BEGIN
   :v_report :=
      dbms_spm.evolve_sql_plan_baseline 
        (sql_handle      => :v_sql_handle,
         verify          => 'YES',
         COMMIT          => 'YES' );
END;
/

SELECT :v_report
  FROM DUAL;

SET autotrace on

SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;
   
set autotrace off

EXPLAIN PLAN FOR 
SELECT /*GHBaseLines1*/ COUNT (*)
  FROM customers JOIN countries USING (country_id)
 WHERE country_name = 'New Zealand'
   AND cust_income_level = 'G: 130,000 - 149,999'
   AND cust_year_of_birth < 1952;
   
select * from TABLE(dbms_xplan.display(null,null,'BASIC +NOTE')); 

 

