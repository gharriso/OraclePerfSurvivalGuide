SPOOL minus
SET serveroutput on

ALTER SESSION SET tracefile_identifier=minus;
ALTER SESSION SET sql_trace=TRUE;

SET lines 120
SET pages 10000
SET timing on
SET echo on
SET arraysize 100

DROP TABLE google_customers;
DROP TABLE microsoft_customers;

CREATE TABLE google_customers
    (cust_id                        NUMBER NOT NULL,
    cust_first_name                VARCHAR2(22)  NOT NULL,
    cust_last_name                 VARCHAR2(40)  NOT NULL,
    cust_gender                    CHAR(1) NOT NULL,
    cust_year_of_birth             NUMBER(4,0) NOT NULL,
    cust_marital_status            VARCHAR2(20),
    cust_street_address            VARCHAR2(40) NOT NULL,
    cust_postal_code               VARCHAR2(10) NOT NULL,
    cust_city                      VARCHAR2(30) NOT NULL,
    cust_city_id                   NUMBER NOT NULL,
    cust_state_province            VARCHAR2(40) NOT NULL,
    cust_state_province_id         NUMBER NOT NULL,
    country_id                     NUMBER NOT NULL,
    cust_main_phone_number         VARCHAR2(25) NOT NULL,
    cust_income_level              VARCHAR2(30),
    cust_credit_limit              NUMBER,
    cust_email                     VARCHAR2(30),
    cust_total                     VARCHAR2(14) NOT NULL,
    cust_total_id                  NUMBER NOT NULL,
    cust_src_id                    NUMBER,
    cust_eff_from                  DATE,
    cust_eff_to                    DATE,
    cust_valid                     VARCHAR2(1)) nologging;

CREATE     TABLE microsoft_customers
    (cust_id                        NUMBER NOT NULL,
    cust_first_name                VARCHAR2(22)  NOT NULL,
    cust_last_name                 VARCHAR2(40)  NOT NULL,
    cust_gender                    CHAR(1) NOT NULL,
    cust_year_of_birth             NUMBER(4,0) NOT NULL,
    cust_marital_status            VARCHAR2(20),
    cust_street_address            VARCHAR2(40) NOT NULL,
    cust_postal_code               VARCHAR2(10) NOT NULL,
    cust_city                      VARCHAR2(30) NOT NULL,
    cust_city_id                   NUMBER NOT NULL,
    cust_state_province            VARCHAR2(40) NOT NULL,
    cust_state_province_id         NUMBER NOT NULL,
    country_id                     NUMBER NOT NULL,
    cust_main_phone_number         VARCHAR2(25) NOT NULL,
    cust_income_level              VARCHAR2(30),
    cust_credit_limit              NUMBER,
    cust_email                     VARCHAR2(30),
    cust_total                     VARCHAR2(14) NOT NULL,
    cust_total_id                  NUMBER NOT NULL,
    cust_src_id                    NUMBER,
    cust_eff_from                  DATE,
    cust_eff_to                    DATE,
    cust_valid                     VARCHAR2(1)) nologging;
 
BEGIN
   FOR i IN 1 .. 4
   LOOP
      INSERT      /*+ append */INTO google_customers
         SELECT c.cust_id,
                   c.cust_first_name
                || ' '
                || CHR (DBMS_RANDOM.VALUE (65, 91)) cust_first_name,
                c.cust_last_name, c.cust_gender, c.cust_year_of_birth,
                c.cust_marital_status, c.cust_street_address,
                c.cust_postal_code, c.cust_city, c.cust_city_id,
                c.cust_state_province, c.cust_state_province_id,
                c.country_id, c.cust_main_phone_number, c.cust_income_level,
                c.cust_credit_limit, c.cust_email, c.cust_total,
                c.cust_total_id, c.cust_src_id, c.cust_eff_from,
                c.cust_eff_to, c.cust_valid
           FROM sh.customers c
          WHERE ROWNUM < 2000000;

      COMMIT;
   END LOOP;
END;
/

BEGIN
   FOR i IN 1 .. 4
   LOOP
      INSERT      /*+ append */INTO microsoft_customers
         SELECT c.cust_id,
                   c.cust_first_name
                || ' '
                || CHR (DBMS_RANDOM.VALUE (65, 91)) cust_first_name,
                c.cust_last_name, c.cust_gender, c.cust_year_of_birth,
                c.cust_marital_status, c.cust_street_address,
                c.cust_postal_code, c.cust_city, c.cust_city_id,
                c.cust_state_province, c.cust_state_province_id,
                c.country_id, c.cust_main_phone_number, c.cust_income_level,
                c.cust_credit_limit, c.cust_email, c.cust_total,
                c.cust_total_id, c.cust_src_id, c.cust_eff_from,
                c.cust_eff_to, c.cust_valid
           FROM sh.customers c
          WHERE ROWNUM < 2000000;

      COMMIT;
   END LOOP;
END;
/

COMMIT ;

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'MICROSOFT_CUSTOMERS'
                                 );
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'GOOGLE_CUSTOMERS'
                                 );
END;
/
 
EXPLAIN PLAN FOR
SELECT cust_first_name, cust_last_name, cust_year_of_birth
  FROM microsoft_customers
MINUS 
SELECT cust_first_name cust_first_name, cust_last_name, cust_year_of_birth
  FROM google_customers;


SELECT *
  FROM TABLE (DBMS_XPLAN.display ());
  
/* Formatted on 2008/11/29 23:06 (Formatter Plus v4.8.7) */
EXPLAIN PLAN FOR
SELECT cust_first_name, cust_last_name, cust_year_of_birth
  FROM microsoft_customers WHERE 
        (cust_first_name, cust_last_name, cust_year_of_birth) NOT IN
        (SELECT cust_first_name, cust_last_name, cust_year_of_birth 
           FROM google_customers);

       
SELECT *
  FROM TABLE (DBMS_XPLAN.display ());       
       

alter system flush shared_pool;

alter system flush buffer_cache; 

DECLARE  /* gh1 minus  */
   CURSOR c1
   IS
      SELECT                                            
             ' gh1 minus' t,cust_first_name  cust_first_name, cust_last_name,
             cust_year_of_birth
        FROM microsoft_customers gh1 
      MINUS
      SELECT '  gh1 minus' t,cust_first_name cust_first_name, cust_last_name,
             cust_year_of_birth
        FROM google_customers;

   r1   c1%ROWTYPE;
BEGIN
   FOR r1 IN c1
   LOOP
      NULL;
   END LOOP;
END;
/

 alter system flush buffer_cache; 
 
DECLARE   /* gh1 anti-join */
   CURSOR c1
   IS
      SELECT ' gh1 anti-join '  t, cust_first_name, cust_last_name,
             cust_year_of_birth
        FROM microsoft_customers
       WHERE (cust_first_name, cust_last_name, cust_year_of_birth) NOT IN (
                   SELECT cust_first_name, cust_last_name,
                          cust_year_of_birth
                     FROM google_customers);

   r1   c1%ROWTYPE;
BEGIN
   FOR r1 IN c1
   LOOP
      NULL;
   END LOOP;
END;
/
alter system flush buffer_cache; 

DECLARE /* gh1 outer-join */
    CURSOR c1 IS
        SELECT ' gh1 outer-join ' t, mc.cust_first_name, mc.cust_last_name,
               mc.cust_year_of_birth
        FROM     microsoft_customers mc
             LEFT OUTER JOIN
                 google_customers gc
             ON (    mc.cust_first_name = gc.cust_first_name
                 AND mc.cust_last_name = gc.cust_last_name
                 AND mc.cust_year_of_birth = gc.cust_year_of_birth)
        WHERE     gc.cust_first_name IS NULL
              AND gc.cust_last_name IS NULL
              AND gc.cust_year_of_birth IS NULL;
    r1   c1%ROWTYPE;
BEGIN
    FOR r1 IN c1 LOOP
        NULL;
    END LOOP;
END;
/


SET autotrace off

COL exec format 9999
COL ela format     99999999
COL sortime format 99999999
COL mem_mb  format 9999999
COL iotime format  99999999
COL cputime format 99999999
col rowcnt format 9999999

SELECT SUBSTR (sql_text, 7, 25), operation_type, executions AS exec,
       elapsed_time AS ela, active_time AS sortime,
       user_io_wait_time AS iotime, cpu_time AS cputime,ROWS_PROCESSED as rowcnt,
       ROUND (last_memory_used / 1048576) AS mem_mb
  FROM v$sql LEFT OUTER JOIN v$sql_workarea USING (sql_id, child_number)
 WHERE sql_text LIKE '% gh1 %' AND sql_text NOT LIKE '%v$sql%';

EXIT;


