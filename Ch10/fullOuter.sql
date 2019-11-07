DEF little_size=100000 
DEF big_size=100000 

SPOOL fullOuter


SET lines 120
SET pages 10000
SET timing on
SET echo on

DROP TABLE bigtable;
DROP TABLE littletable;

CREATE TABLE bigtable AS
SELECT ROWNUM pk, ROUND(DBMS_RANDOM.VALUE(2,1000))  join_key, RPAD(ROWNUM,100,'x') DATA
  FROM DUAL CONNECT BY ROWNUM <&big_size ; 

CREATE TABLE littletable AS
 SELECT ROWNUM pk, ROUND(DBMS_RANDOM.VALUE(1,999))  join_key, RPAD(ROWNUM,100,'x') DATA
  FROM DUAL CONNECT BY ROWNUM <&little_size; 

CREATE INDEX bigtable_i1 ON bigtable(join_key);
CREATE INDEX littletable_i1 ON littletable(join_key);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'BIGTABLE');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'LITTLETABLE');
END;
/
set autotrace on 

alter system flush buffer_cache; 

select count(*), min(join_key), max(join_key) , max(l.data),max(b.data)
  from bigtable b full outer join littletable l using (join_key) 
 where join_key in (1,1000); 
 
alter system flush buffer_cache; 
 
 select /*+ ordered use_nl(l) */ count(*), min(join_key), max(join_key) , max(l.data),max(b.data)
  from bigtable b full outer join littletable l using (join_key) 
 where join_key in (1,1000); 
 
alter system flush buffer_cache; 
  
 select /*+ ordered use_merge(l) */ count(*), min(join_key), max(join_key) , max(l.data),max(b.data)
  from bigtable b full outer join littletable l using (join_key) 
 where join_key in (1,1000); 
 
 exit;

