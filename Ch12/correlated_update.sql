
SET serveroutput on

ALTER SESSION SET tracefile_identifier=cupdate;
SPOOL cupdate
ALTER SESSION SET sql_trace=TRUE;

SET lines 120
SET pages 10000
SET timing on
SET echo on
SET arraysize 100

DROP TABLE customers;
DROP TABLE customer_updates;

CREATE TABLE  customers
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

CREATE     TABLE customer_updates
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
   FOR i IN 1 .. 1
   LOOP
      INSERT      /*+ append */INTO customers
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
   FOR i IN 1 .. 1
   LOOP
      INSERT      /*+ append */INTO customer_updates
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
                                  tabname      => 'CUSTOMERS'
                                 );
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMER_UPDATES'
                                 );
END;
/


