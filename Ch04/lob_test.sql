/* Formatted on 2008/08/19 10:25 (Formatter Plus v4.8.7) */
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
ALTER SESSION SET tracefile_identifier=lob_test;


DROP TABLE lob_inline;
DROP TABLE lob_no_inline;

CREATE TABLE lob_inline
    ( ID NUMBER PRIMARY KEY,
      vchar_col VARCHAR2(1024),
      lob_col CLOB )
 LOB(lob_col) STORE AS (ENABLE STORAGE IN ROW);

CREATE  TABLE lob_no_inline
    ( ID NUMBER PRIMARY KEY,
      vchar_col VARCHAR2(1024),
      lob_col CLOB )
 LOB(lob_col) STORE AS (DISABLE STORAGE IN ROW);

INSERT INTO lob_inline
            (ID, vchar_col, lob_col)
   SELECT     ROWNUM, RPAD ('x', 500, ROWNUM), RPAD ('x', 3000, ROWNUM)
         FROM DUAL
   CONNECT BY ROWNUM < 20000;

INSERT INTO lob_no_inline
            (ID, vchar_col, lob_col)
   SELECT     ROWNUM, RPAD ('x', 500, ROWNUM), RPAD ('x', 3000, ROWNUM)
         FROM DUAL
   CONNECT BY ROWNUM < 20000;

COMMIT ;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'LOB_INLINE');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'LOB_NO_INLINE');
END;
/


DECLARE
   TYPE nt IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE vt IS TABLE OF VARCHAR2 (1024)
      INDEX BY BINARY_INTEGER;

   TYPE ct IS TABLE OF lob_inline.lob_col%TYPE
      INDEX BY BINARY_INTEGER;

   nt1   nt;
   vt1   vt;
   ct1   ct;
   nt2   nt;
   vt2   vt;
   ct2   ct;
BEGIN
   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   FOR i IN 1 .. 2
   LOOP
      SELECT ID, vchar_col, lob_col
      BULK COLLECT INTO nt1, vt1, ct1
        FROM lob_inline;
   END LOOP;

   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   FOR i IN 1 .. 2
   LOOP
      SELECT ID, vchar_col
      BULK COLLECT INTO nt1, vt1
        FROM lob_inline;
   END LOOP;

   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   FOR i IN 1 .. 2
   LOOP
      SELECT ID, vchar_col, lob_col
      BULK COLLECT INTO nt2, vt2, ct2
        FROM lob_no_inline;
   END LOOP;

   EXECUTE IMMEDIATE 'alter system flush buffer_cache';

   FOR i IN 1 .. 2
   LOOP
      SELECT ID, vchar_col
      BULK COLLECT INTO nt2, vt2
        FROM lob_no_inline;
   END LOOP;
END;
/

EXIT

