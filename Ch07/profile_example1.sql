/* Formatted on 2008/09/11 22:41 (Formatter Plus v4.8.7) */
SPOOL profiles1

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

SELECT /* OPSG Profile example */ *
  FROM customers JOIN countries USING (country_id)
 WHERE cust_marital_status = 'Mar-AF'
   AND country_name = 'United States of America'
   AND cust_year_of_birth > 1960;
SET autotrace off

explain plan for 
SELECT /* OPSG Profile example */ *
  FROM customers JOIN countries USING (country_id)
 WHERE cust_marital_status = 'Mar-AF'
   AND country_name = 'United States of America'
   AND cust_year_of_birth > 1960;
   
select * from table(dbms_xplan.display(null, null, 'BASIC',null)); 
   
   


SELECT sql_id, sql_text
  FROM v$sql
 WHERE sql_text LIKE 'SELECT /* OPSG Profile example%';

VARIABLE v_task_name varchar2(30)
VARIABLE v_sql_id varchar2(20)
VARIABLE v_report clob;
VARIABLE v_script clob;

BEGIN
   SELECT sql_id
     INTO :v_sql_id
     FROM v$sql
    WHERE sql_text LIKE 'SELECT /* OPSG Profile example%';
END;
/

SET serveroutput on

BEGIN
   :v_task_name := DBMS_SQLTUNE.create_tuning_task (sql_id => :v_sql_id);
   DBMS_OUTPUT.put_line (:v_task_name);
   DBMS_SQLTUNE.execute_tuning_task (:v_task_name);
   COMMIT;
END;
/

SELECT *
  FROM dba_advisor_log
 WHERE task_name = :v_task_name;

BEGIN
   :v_report := DBMS_SQLTUNE.report_tuning_task (:v_task_name);
   :v_script := DBMS_SQLTUNE.script_tuning_task (:v_task_name);
END;
/

select :v_report from dual;
select :v_script from dual; 

column attr_value format a60

SELECT attr_value
  FROM dba_sql_profiles p JOIN dbmshsxp_sql_profile_attr a
       ON (a.profile_name = p.NAME)
 WHERE p.NAME = 'SYS_SQLPROF_0147146e15ff0000';

