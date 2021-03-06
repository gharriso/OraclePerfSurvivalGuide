set echo on
col event format a30
set autotrace on
rem DROP TABLE txn_data;

CREATE TABLE txn_data
PARALLEL(DEGREE 4)
NOLOGGING AS
   SELECT ROWNUM txn_id, SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
          RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900, 'x') tdata
   FROM DUAL
   CONNECT BY ROWNUM < &1;

ALTER TABLE txn_data ADD CONSTRAINT txn_data_pk PRIMARY KEY (txn_id);

ALTER SESSION ENABLE PARALLEL DML;

BEGIN
   FOR i IN 1 .. &2 LOOP
        INSERT /*+ append  parallel(d,4) */
            INTO txn_data d (txn_id, datetime, tdata)
         SELECT maxid + txn_id, datetime, tdata
         FROM (SELECT ROWNUM txn_id,
                      SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000) datetime,
                      RPAD(SYSDATE - 1000 + DBMS_RANDOM.VALUE(1, 1000), 900,
                      'x')
                         tdata
               FROM DUAL
               CONNECT BY ROWNUM < &1) l, (SELECT MAX(txn_id) maxid FROM txn_data);

      COMMIT;
   END LOOP;
END;
/
/* Formatted on 18-Feb-2009 18:55:55 (QP5 v5.120.811.25008) */
