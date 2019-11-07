/* Formatted on 2008/11/06 19:24 (Formatter Plus v4.8.7) */
SPOOL sm_vs_hash


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=sm_vs_hash;

drop  table sorted1; 
drop  table sorted2;
drop  table unsorted1;
drop  table unsorted2;

CREATE TABLE sorted1 AS
SELECT ROWNUM sortKey,RPAD('x',100,'x') data1 FROM DUAL CONNECT BY rownum  <&&tableSizes
 ORDER BY ROWNUM;
 
CREATE TABLE sorted2 AS
SELECT ROWNUM sortKey,RPAD('x',100,'x') data2  FROM DUAL CONNECT BY rownum  <&&tableSizes
 ORDER BY ROWNUM; 

CREATE TABLE unsorted1 AS
SELECT ROWNUM sortKey,RPAD('x',100,'x')  data1 FROM DUAL CONNECT BY rownum  <&&tableSizes
 ORDER BY dbms_random.value();
 
CREATE TABLE unsorted2 AS
SELECT ROWNUM sortKey,RPAD('x',100,'x') data2 FROM DUAL CONNECT BY rownum  <&&tableSizes
 ORDER BY dbms_random.value();
 
BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SORTED1');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SORTED2');

   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'UNSORTED1');

   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'UNSORTED2');

END;
/ 
 
set autotrace on


alter system flush buffer_cache; 
 
/* Formatted on 2008/11/06 19:44 (Formatter Plus v4.8.7) */
SELECT   /*+ ordered use_hash(b) */
         MAX (data1), MAX (data2)
    FROM sorted1 a JOIN sorted2 b USING (sortkey)
ORDER BY sortkey;
 
 

alter system flush buffer_cache; 
 
/* Formatted on 2008/11/06 19:44 (Formatter Plus v4.8.7) */
SELECT   /*+ ordered use_merge(b) */
         MAX (data1), MAX (data2)
    FROM sorted1 a JOIN sorted2 b USING (sortkey)
ORDER BY sortkey;
 
 

alter system flush buffer_cache; 
 
/* Formatted on 2008/11/06 19:44 (Formatter Plus v4.8.7) */
SELECT   /*+ ordered use_hash(b) */
         MAX (data1), MAX (data2)
    FROM unsorted1 a JOIN unsorted2 b USING (sortkey)
ORDER BY sortkey;

 
alter system flush buffer_cache; 

 
/* Formatted on 2008/11/06 19:44 (Formatter Plus v4.8.7) */
SELECT   /*+ ordered use_merge(b) */
         MAX (data1), MAX (data2)
    FROM unsorted1 a JOIN unsorted2 b USING (sortkey)
ORDER BY sortkey;

 exit;  
