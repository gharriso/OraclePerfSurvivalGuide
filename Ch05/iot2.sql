/* Formatted on 2008/08/21 21:30 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=iot2;

SET pages 1000
SET lines 160
SET echo on
SET timing on
rem possible bug workaround. 
BEGIN
sys.dbms_scheduler.disable( '"SYS"."AUTO_SPACE_ADVISOR_JOB"' );
END; 
/

SPOOL iot2
REM
REM object creation here
REM
 
DROP TABLE survey_iot_ovrflow;
DROP TABLE survey_iot_no_ovrflow;
DROP TABLE survey_heap;
DROP TABLE survey_customers;

 
CREATE TABLE survey_customers AS
 SELECT * FROM sh.customers WHERE rownum<1001;

 
ALTER TABLE survey_customers ADD PRIMARY KEY (cust_id);

 
CREATE TABLE survey_iot_ovrflow
    (cust_id                NUMBER          NOT NULL ,
    question_id             NUMBER          NOT NULL,
    question_score          NUMBER          NOT NULL,
    question_long_answer    VARCHAR2(1000)  NOT NULL,
    primary key (cust_id,question_id) )  
ORGANIZATION INDEX INCLUDING question_score OVERFLOW;

CREATE TABLE survey_iot_no_ovrflow
    (cust_id                NUMBER          NOT NULL ,
    question_id             NUMBER          NOT NULL,
    question_score          NUMBER          NOT NULL,
    question_long_answer    VARCHAR2(1000)  NOT NULL,
    primary key (cust_id,question_id) ) 
ORGANIZATION INDEX INCLUDING question_long_answer  OVERFLOW;


CREATE TABLE survey_heap
    (cust_id                NUMBER          NOT NULL ,
    question_id             NUMBER          NOT NULL,
    question_score          NUMBER          NOT NULL,
    question_long_answer    VARCHAR2(1000)  NOT NULL,
    primary key (cust_id,question_id) ) 
ORGANIZATION HEAP;


truncate table survey_heap; 
DECLARE
   TYPE nt IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE vc IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   ci    nt;
   qi    nt;
   qs    nt;
   qla   vc;
BEGIN
   FOR i IN 1 .. 100
   LOOP
      ci.delete;
      qi.delete;
      qs.delete;
      qla.delete;
      SELECT     cust_id, i, DBMS_RANDOM.VALUE (10, 90),
                 RPAD (ROWNUM, 500, ROWNUM)
      BULK COLLECT INTO ci, qi, qs,
                 qla
            FROM survey_customers;

      FORALL i IN 1 .. 100
         INSERT INTO survey_heap
                     (cust_id, question_id, question_score,
                      question_long_answer
                     )
              VALUES (ci (i), qi (i), qs (i),
                      qla (i)
                     );
   END LOOP;

   COMMIT;
END;
/


/* Formatted on 2008/08/22 09:15 (Formatter Plus v4.8.7) */
INSERT INTO survey_iot_ovrflow
   SELECT *
     FROM survey_heap;
COMMIT ;
INSERT INTO survey_iot_no_ovrflow
   SELECT *
     FROM survey_heap;
COMMIT ;

 

BEGIN
   DBMS_SESSION.session_trace_enable (waits => TRUE, binds => FALSE
                                                                   --,plan_stat      => 'all_executions'
   );
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SURVEY_IOT_NO_OVRFLOW');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SURVEY_IOT_OVRFLOW'); 
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SURVEY_HEAP'); 
END;
/

SET autotrace on
REM
REM Queries, etc, here
REM

/* Formatted on 2008/08/22 09:16 (Formatter Plus v4.8.7) */
SELECT SUM (question_score)
  FROM survey_iot_ovrflow c
 WHERE cust_id = 3228;
SELECT SUM (question_score)
  FROM survey_iot_no_ovrflow c
 WHERE cust_id = 3228;
SELECT SUM (question_score)
  FROM survey_heap c
 WHERE cust_id = 3228;

SELECT MAX (question_long_answer)
  FROM survey_iot_ovrflow c
 WHERE cust_id = 3228;
SELECT MAX (question_long_answer)
  FROM survey_iot_no_ovrflow c
 WHERE cust_id = 3228;
SELECT MAX (question_long_answer)
  FROM survey_heap c
 WHERE cust_id = 3228;

SELECT SUM (question_score)
  FROM survey_iot_ovrflow c;
SELECT SUM (question_score)
  FROM survey_iot_no_ovrflow c;
SELECT SUM (question_score)
  FROM survey_heap c;
      
SELECT MAX (question_long_answer)
  FROM survey_iot_ovrflow c;
SELECT MAX (question_long_answer)
  FROM survey_iot_no_ovrflow c;
SELECT MAX (question_long_answer)
  FROM survey_heap c;
  
SET autotrace off
SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

