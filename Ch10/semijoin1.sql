/* Formatted on 2008/11/20 15:55 (Formatter Plus v4.8.7) */
SPOOL semijoin
SET serveroutput on

ALTER SESSION SET tracefile_identifier=semijoin;


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

commit; 

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'MICROSOFT_CUSTOMERS'
                                 );
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'GOOGLE_CUSTOMERS'
                                 );
END;
/

ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';

SET autotrace on

SELECT COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);
                                          
 
SELECT COUNT (*)
  FROM google_customers g
 WHERE EXISTS (
          SELECT 0
            FROM microsoft_customers m
           WHERE m.cust_first_name = g.cust_first_name
             AND m.cust_last_name = g.cust_last_name);
             
create index microsoft_customer_name_i on microsoft_customers(cust_last_name,cust_first_name); 

SELECT COUNT (*)
  FROM google_customers
 WHERE (cust_first_name, cust_last_name) IN (
                                        SELECT cust_first_name,
                                               cust_last_name
                                          FROM microsoft_customers);
                                          
 
SELECT COUNT (*)
  FROM google_customers g
 WHERE EXISTS (
          SELECT 0
            FROM microsoft_customers m
           WHERE m.cust_first_name = g.cust_first_name
             AND m.cust_last_name = g.cust_last_name);
 

EXIT;

