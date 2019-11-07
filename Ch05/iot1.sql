/* Formatted on 2008/08/21 21:30 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=iot1;

SET pages 1000
SET lines 160
SET echo on
SET timing on
rem possible bug workaround. 
BEGIN
sys.dbms_scheduler.disable( '"SYS"."AUTO_SPACE_ADVISOR_JOB"' );
END; 
/

SPOOL iot1
REM
REM object creation here
REM
DROP TABLE customers_iot_ovrflow;
DROP TABLE customers_iot_no_ovrflow;
drop table customers_heap; 
CREATE TABLE customers_iot_ovrflow
    (cust_id                NUMBER NOT NULL PRIMARY KEY,
    cust_first_name         VARCHAR2(20) NOT NULL,
    cust_last_name          VARCHAR2(40) NOT NULL,
    cust_gender             CHAR(1) NOT NULL,
    cust_year_of_birth      NUMBER(4,0) NOT NULL,
    cust_marital_status     VARCHAR2(20),
    cust_street_address     VARCHAR2(40) NOT NULL,
    cust_postal_code        VARCHAR2(10) NOT NULL,
    cust_city               VARCHAR2(30) NOT NULL,
    comments1               VARCHAR2(2000) NULL,
    cust_profile            VARCHAR2(2000) NULL
  )
ORGANIZATION INDEX INCLUDING cust_gender OVERFLOW;

CREATE TABLE customers_iot_no_ovrflow
    (cust_id                NUMBER NOT NULL PRIMARY KEY,
    cust_first_name         VARCHAR2(20) NOT NULL,
    cust_last_name          VARCHAR2(40) NOT NULL,
    cust_gender             CHAR(1) NOT NULL,
    cust_year_of_birth      NUMBER(4,0) NOT NULL,
    cust_marital_status     VARCHAR2(20),
    cust_street_address     VARCHAR2(40) NOT NULL,
    cust_postal_code        VARCHAR2(10) NOT NULL,
    cust_city               VARCHAR2(30) NOT NULL,
    comments1               VARCHAR2(2000) NULL,
    cust_profile            VARCHAR2(2000) NULL
  )
ORGANIZATION INDEX PCTTHRESHOLD 50 overflow ;

CREATE TABLE customers_heap
    (cust_id                NUMBER NOT NULL PRIMARY KEY,
    cust_first_name         VARCHAR2(20) NOT NULL,
    cust_last_name          VARCHAR2(40) NOT NULL,
    cust_gender             CHAR(1) NOT NULL,
    cust_year_of_birth      NUMBER(4,0) NOT NULL,
    cust_marital_status     VARCHAR2(20),
    cust_street_address     VARCHAR2(40) NOT NULL,
    cust_postal_code        VARCHAR2(10) NOT NULL,
    cust_city               VARCHAR2(30) NOT NULL,
    comments1               VARCHAR2(2000) NULL,
    cust_profile            VARCHAR2(2000) NULL
  )
ORGANIZATION HEAP;

alter system flush buffer_cache; 

INSERT INTO customers_iot_ovrflow
   SELECT c.cust_id, c.cust_first_name, c.cust_last_name, c.cust_gender,
          c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address,
          c.cust_postal_code, c.cust_city, RPAD ('x', 1000, ROWNUM),
          RPAD ('y', 1000, ROWNUM)
     FROM sh.customers c;

INSERT INTO customers_iot_no_ovrflow
   SELECT c.cust_id, c.cust_first_name, c.cust_last_name, c.cust_gender,
          c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address,
          c.cust_postal_code, c.cust_city, RPAD ('x', 1000, ROWNUM),
          RPAD ('y', 1000, ROWNUM)
     FROM sh.customers c;
     
INSERT INTO customers_heap
   SELECT c.cust_id, c.cust_first_name, c.cust_last_name, c.cust_gender,
          c.cust_year_of_birth, c.cust_marital_status, c.cust_street_address,
          c.cust_postal_code, c.cust_city, RPAD ('x', 1000, ROWNUM),
          RPAD ('y', 1000, ROWNUM)
     FROM sh.customers c;

commit; 

BEGIN
   DBMS_SESSION.session_trace_enable (waits => TRUE, binds => FALSE
                                                                   --,plan_stat      => 'all_executions'
   );
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_IOT_NO_OVRFLOW');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_IOT_OVRFLOW'); 
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_HEAP'); 
END;
/

SET autotrace on
REM
REM Queries, etc, here
REM
select c.cust_first_name, c.cust_last_name, c.cust_gender from customers_iot_ovrflow c where cust_id=505; 
select c.cust_first_name, c.cust_last_name, c.cust_gender from customers_iot_no_ovrflow c where cust_id=505; 
select c.cust_first_name, c.cust_last_name, c.cust_gender from customers_heap c where cust_id=505; 

select c.cust_first_name, c.cust_last_name, c.cust_gender,substr(cust_profile,1,10) from customers_iot_ovrflow c where cust_id=505; 
select c.cust_first_name, c.cust_last_name, c.cust_gender,substr(cust_profile,1,10) from customers_iot_no_ovrflow c where cust_id=505; 
select c.cust_first_name, c.cust_last_name, c.cust_gender,substr(cust_profile,1,10) from customers_heap c where cust_id=505; 

select 

SET autotrace off
SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

