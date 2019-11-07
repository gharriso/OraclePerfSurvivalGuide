/* Formatted on 2008/10/28 22:56 (Formatter Plus v4.8.7) */
SPOOL hwm


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=hwm;

ALTER SESSION SET sql_trace= TRUE;

DROP TABLE hwm_test;

CREATE TABLE hwm_test (pk INT PRIMARY KEY, DATA VARCHAR2(2000));

INSERT INTO hwm_test
            (pk, DATA)
   SELECT     ROWNUM, RPAD ('rownum', 1400, 'x')
         FROM DUAL
   CONNECT BY ROWNUM < 2000;

COMMIT ;

set autotrace on 

SELECT /*  2000 rows */  MAX (DATA)
  FROM hwm_test;

INSERT INTO hwm_test
            (pk, DATA)
   WITH maxpk AS
        (SELECT /*+ materialize */
                MAX (pk) maxpk
           FROM hwm_test)
   SELECT     maxpk + ROWNUM x, RPAD ('rownum', 1400, 'x') y
         FROM maxpk
   CONNECT BY ROWNUM < 100000;
   
commit;
SELECT /* 102000 rows */ MAX (DATA)
  FROM hwm_test;
  
delete from hwm_test where pk>2000; 

commit; 

SELECT /* After delete of 100000 */ MAX (DATA)
  FROM hwm_test;

alter table hwm_test enable row movement; 
alter table hwm_test shrink space ; 

 
SELECT /* After shrink */ MAX (DATA)
  FROM hwm_test;

INSERT INTO hwm_test
            (pk, DATA)
   WITH maxpk AS
        (SELECT /*+ materialize */
                MAX (pk) maxpk
           FROM hwm_test)
   SELECT     maxpk + ROWNUM x, RPAD ('rownum', 1400, 'x') y
         FROM maxpk
   CONNECT BY ROWNUM < 100000;

COMMIT ;

DELETE FROM hwm_test
      WHERE pk > 1000 AND ROWNUM < 100000;

COMMIT ;

SELECT /* After delete of middle rows */ MAX (DATA)
  FROM hwm_test;

alter table hwm_test enable row movement; 
alter table hwm_test shrink space ; 

SELECT /* After 2nd shrink */ MAX (DATA)
  FROM hwm_test;


EXIT;



