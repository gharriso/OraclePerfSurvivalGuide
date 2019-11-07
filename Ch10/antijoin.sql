/* Formatted on 2008/11/18 14:07 (Formatter Plus v4.8.7) */
SPOOL antijoin
SET serveroutput on

ALTER SESSION SET tracefile_identifier=antijoin;


SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE google_customers;
DROP TABLE microsoft_customers;

CREATE TABLE google_customers
    (cust_id                        NUMBER NOT NULL,
    cust_first_name                VARCHAR2(22)  NULL,
    cust_last_name                 VARCHAR2(40)  NULL,
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
    cust_valid                     VARCHAR2(1));

CREATE     TABLE microsoft_customers
    (cust_id                        NUMBER NOT NULL,
    cust_first_name                VARCHAR2(22)  NULL,
    cust_last_name                 VARCHAR2(40)  NULL,
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
    cust_valid                     VARCHAR2(1));

insert into google_customers  
SELECT c.cust_id, c.cust_first_name||' '||CHR(DBMS_RANDOM.VALUE(65,91)) cust_first_name, c.cust_last_name, c.cust_gender, c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address, c.cust_postal_code, c.cust_city, c.cust_city_id, c.cust_state_province, c.cust_state_province_id, c.country_id, c.cust_main_phone_number, c.cust_income_level, c.cust_credit_limit, c.cust_email, c.cust_total, c.cust_total_id, c.cust_src_id, c.cust_eff_from, c.cust_eff_to, c.cust_valid
FROM sh.customers c WHERE ROWNUM<2000;

insert into   microsoft_customers  
SELECT c.cust_id, c.cust_first_name||' '||CHR(DBMS_RANDOM.VALUE(65,91)) cust_first_name, c.cust_last_name, c.cust_gender, c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address, c.cust_postal_code, c.cust_city, c.cust_city_id, c.cust_state_province, c.cust_state_province_id, c.country_id, c.cust_main_phone_number, c.cust_income_level, c.cust_credit_limit, c.cust_email, c.cust_total, c.cust_total_id, c.cust_src_id, c.cust_eff_from, c.cust_eff_to, c.cust_valid
FROM sh.customers c WHERE ROWNUM<2000;

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'MICROSOFT_CUSTOMERS'
                                 );
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'GOOGLE_CUSTOMERS'
                                 );
END;
/

SET autotrace on

 alter system flush buffer_cache; 
/* Formatted on 2008/11/18 14:20 (Formatter Plus v4.8.7) */
SELECT COUNT (*)
  FROM google_customers 
 WHERE NOT EXISTS (
          SELECT 0
            FROM "MICROSOFT_CUSTOMERS" "MICROSOFT_CUSTOMERS"
           WHERE lnnvl ("MICROSOFT_CUSTOMERS"."CUST_FIRST_NAME" <>
                                          "GOOGLE_CUSTOMERS"."CUST_FIRST_NAME")
             AND lnnvl ("MICROSOFT_CUSTOMERS"."CUST_LAST_NAME" <>
                                           "GOOGLE_CUSTOMERS"."CUST_LAST_NAME")); 
 alter system flush buffer_cache; 
 
SELECT /*  Nulls - No index  */
       COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) NOT IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);
                                          

SELECT   /*  not null where clause - No index  */
       COUNT (*)
  FROM google_customers
 WHERE cust_first_name IS NOT NULL
   AND cust_last_name IS NOT NULL
   AND (cust_first_name, cust_last_name) NOT IN (
              SELECT cust_first_name, cust_last_name
                FROM microsoft_customers
               WHERE cust_first_name IS NOT NULL
                     AND cust_last_name IS NOT NULL);


 alter system flush buffer_cache; 
 
SELECT /*  Nulls - No index  */
       COUNT (*)
  FROM google_customers gc
 WHERE NOT EXISTS (
          SELECT 0
            FROM microsoft_customers mc
           WHERE mc.cust_first_name = gc.cust_first_name
             AND mc.cust_last_name = gc.cust_last_name);


CREATE INDEX msft_cust_names_i ON
    microsoft_customers(cust_first_name,cust_last_name)
    COMPUTE STATISTICS;

 alter system flush buffer_cache; 
 
SELECT /*  Nulls -  index  */
       COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) NOT IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);

 alter system flush buffer_cache; 
 
SELECT /*  Nulls -  index  */
       COUNT (*)
  FROM google_customers gc
 WHERE NOT EXISTS (
          SELECT 0
            FROM microsoft_customers mc
           WHERE mc.cust_first_name = gc.cust_first_name
             AND mc.cust_last_name = gc.cust_last_name);

DROP INDEX msft_cust_names_i;

ALTER  TABLE microsoft_customers MODIFY cust_first_name NOT NULL;
ALTER   TABLE microsoft_customers MODIFY cust_last_name NOT NULL;
ALTER  TABLE google_customers MODIFY cust_first_name NOT NULL;
ALTER   TABLE google_customers MODIFY cust_last_name NOT NULL;

 alter system flush buffer_cache; 
 
SELECT /*  No  Nulls - No index  */
       COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) NOT IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);

 alter system flush buffer_cache; 
 
SELECT /*  No Nulls - No index  */
       COUNT (*)
  FROM google_customers gc
 WHERE NOT EXISTS (
          SELECT 0
            FROM microsoft_customers mc
           WHERE mc.cust_first_name = gc.cust_first_name
             AND mc.cust_last_name = gc.cust_last_name);


CREATE INDEX msft_cust_names_i ON
    microsoft_customers(cust_first_name,cust_last_name)
    COMPUTE STATISTICS;

ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';
 
alter system flush buffer_cache; 
 
SELECT /*  No Nulls -  index  */
       COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) NOT IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);

 alter system flush buffer_cache; 
 
SELECT /*+ No Nulls -  index  */
       COUNT (*)
  FROM google_customers gc
 WHERE NOT EXISTS (
          SELECT 0
            FROM microsoft_customers mc
           WHERE mc.cust_first_name = gc.cust_first_name
             AND mc.cust_last_name = gc.cust_last_name);



EXIT;

