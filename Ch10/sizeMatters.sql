/* Formatted on 2008/11/13 15:43 (Formatter Plus v4.8.7) */
DEF little_size=100000 
DEF big_size=1000000 

DROP TABLE bigtable;
DROP TABLE littletable;

CREATE TABLE bigtable AS
SELECT ROWNUM pk, ROUND(DBMS_RANDOM.VALUE(1,&little_size))  join_key, RPAD(ROWNUM,100,'x') DATA
  FROM DUAL CONNECT BY ROWNUM <&big_size ; 

CREATE TABLE littletable AS
 SELECT ROWNUM pk, ROUND(DBMS_RANDOM.VALUE(1,&little_size))  join_key, RPAD(ROWNUM,100,'x') DATA
  FROM DUAL CONNECT BY ROWNUM <&little_size; 

CREATE INDEX bigtable_i1 ON bigtable(join_key);
CREATE INDEX littletable_i1 ON littletable(join_key);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'BIGTABLE');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'LITTLETABLE');
END;
/

SET autotrace on
SPOOL size_matters


SET lines 120
SET pages 10000
SET timing on
SET echo on

alter system flush buffer_cache; 
SELECT /*+ ordered use_hash(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM bigtable a JOIN littletable b USING (join_key)
       ;
alter system flush buffer_cache; 

SELECT /*+ ordered use_hash(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM littletable a JOIN bigtable b USING (join_key)
       ;
alter system flush buffer_cache; 

SELECT /*+ ordered use_merge(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM bigtable a JOIN littletable b USING (join_key)
       ;
alter system flush buffer_cache; 

SELECT /*+ ordered use_merge(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM littletable a JOIN bigtable b USING (join_key)
       ;
alter system flush buffer_cache; 

SELECT /*+ ordered use_nl(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM bigtable a JOIN littletable b USING (join_key)
       ;
alter system flush buffer_cache; 

SELECT /*+ ordered use_nl(b) */
       MAX (a.DATA), MAX (b.DATA)
  FROM littletable a JOIN bigtable b USING (join_key)
       ;

EXIT;

