/* Formatted on 2008/08/22 16:57 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=NESTED;

SET pages 1000
SET lines 160
SET echo on
SET timing on

SPOOL nested
DROP TABLE subjects_nt_survey;
DROP TABLE subjects_ntiot_survey;
 

CREATE OR REPLACE TYPE survey_ot AS OBJECT (
   item_number   NUMBER,
   score         INT
);
/

CREATE OR REPLACE TYPE survey_nt_typ AS TABLE OF survey_ot;
/


CREATE TABLE customers_nt_survey
(
    cust_id                 NUMBER NOT NULL PRIMARY KEY,
    cust_first_name         VARCHAR2(20) NOT NULL,
    cust_last_name          VARCHAR2(40) NOT NULL,
    cust_gender             CHAR(1) NOT NULL,
    cust_year_of_birth      NUMBER(4,0) NOT NULL,
    cust_marital_status     VARCHAR2(20),
    cust_street_address     VARCHAR2(40) NOT NULL,
    cust_postal_code        VARCHAR2(10) NOT NULL,
    cust_city               VARCHAR2(30) NOT NULL,
    survey                  survey_nt_typ )
  NESTED TABLE survey STORE AS survey_nt;

CREATE TABLE customers_ntiot_survey
(
    cust_id                 NUMBER NOT NULL PRIMARY KEY,
    cust_first_name         VARCHAR2(20) NOT NULL,
    cust_last_name          VARCHAR2(40) NOT NULL,
    cust_gender             CHAR(1) NOT NULL,
    cust_year_of_birth      NUMBER(4,0) NOT NULL,
    cust_marital_status     VARCHAR2(20),
    cust_street_address     VARCHAR2(40) NOT NULL,
    cust_postal_code        VARCHAR2(10) NOT NULL,
    cust_city               VARCHAR2(30) NOT NULL,
    survey                  survey_nt_typ )
  NESTED TABLE survey STORE AS survey_nt_iot
   ((PRIMARY KEY(nested_table_id,item_number) )
    ORGANIZATION INDEX COMPRESS);


/* Formatted on 2008/08/22 17:04 (Formatter Plus v4.8.7) */
INSERT INTO customers_nt_survey
            (cust_id, cust_gender, cust_first_name, cust_last_name,
             cust_year_of_birth, cust_marital_status, cust_street_address,
             cust_postal_code, cust_city, survey)
   SELECT c.cust_id, c.cust_gender, c.cust_first_name, c.cust_last_name,
          c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address,
          c.cust_postal_code, c.cust_city,
          CAST (MULTISET (SELECT     ROWNUM, DBMS_RANDOM.VALUE (10, 90)
                                FROM DUAL
                          CONNECT BY ROWNUM < 100) AS survey_nt_typ
               )
     FROM sh.customers c
    WHERE ROWNUM <= 1000;

INSERT INTO customers_ntiot_survey
            (cust_id, cust_gender, cust_first_name, cust_last_name,
             cust_year_of_birth, cust_marital_status, cust_street_address,
             cust_postal_code, cust_city, survey)
   SELECT c.cust_id, c.cust_gender, c.cust_first_name, c.cust_last_name,
          c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address,
          c.cust_postal_code, c.cust_city,
          CAST (MULTISET (SELECT     ROWNUM, DBMS_RANDOM.VALUE (10, 90)
                                FROM DUAL
                          CONNECT BY ROWNUM < 100) AS survey_nt_typ
               )
     FROM sh.customers c
    WHERE ROWNUM <= 1000;



BEGIN
   DBMS_SESSION.session_trace_enable (waits => TRUE, binds => FALSE);
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'customers_NT_survey'
                                 );
END;
/

SET autotrace on
REM
REM Queries, etc, here
REM
select cust_id, cust_gender, cust_first_name, cust_last_name,
             cust_year_of_birth, cust_marital_status, cust_street_address,
             cust_postal_code, cust_city, survey from customers_nt_survey where cust_id= 3228;
select cust_id, cust_gender, cust_first_name, cust_last_name,
             cust_year_of_birth, cust_marital_status, cust_street_address,
             cust_postal_code, cust_city, survey from customers_ntiot_survey where cust_id= 3228;

SET autotrace off
SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

