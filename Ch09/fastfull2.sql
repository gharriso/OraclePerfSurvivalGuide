/* Formatted on 2008/11/03 10:18 (Formatter Plus v4.8.7) */
SPOOL ffs2


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=ffs2;

ALTER SESSION SET sql_trace= TRUE;

 DROP TABLE ffs_longrow;
DROP TABLE ffs_shortrow;

CREATE TABLE ffs_longrow (pk NUMBER PRIMARY KEY, CATEGORY NUMBER NOT NULL, num_data NUMBER NOT NULL, varchar_data VARCHAR2(1000) NOT NULL);
INSERT INTO ffs_longrow
   SELECT     ROWNUM pk, MOD (ROWNUM, 10) CATEGORY, MOD (ROWNUM,
                                                         100) num_data,
              RPAD ('x', 512, 'x') varchar_data
         FROM DUAL
   CONNECT BY ROWNUM < 1000000;

CREATE TABLE ffs_shortrow (pk NUMBER PRIMARY KEY, CATEGORY NUMBER NOT NULL, num_data NUMBER NOT NULL);
INSERT INTO ffs_shortrow
   SELECT     ROWNUM pk, MOD (ROWNUM, 10) CATEGORY, MOD (ROWNUM,
                                                         100) num_data
         FROM DUAL
   CONNECT BY ROWNUM < 1000000;

CREATE INDEX ffs_longrow_i1 ON ffs_longrow(CATEGORY,num_data);
CREATE INDEX ffs_shortrow_i1 ON ffs_shortrow(CATEGORY,num_data);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'FFS_LONGROW');
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'FFS_SHORTROW');
END; 
/

SELECT   /*+ FULL(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;
 
SELECT   /*+ FULL(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;
 
SELECT   /*+ INDEX_FFS(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;
 
SELECT   /*+ INDEX_FFS(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;
 
SELECT   /*+ INDEX(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;
 
SELECT   /*+ INDEX(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;

 
SET autotrace on

alter system flush buffer_cache; 
SELECT   /*+ FULL(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;

alter system flush buffer_cache;  
SELECT   /*+ FULL(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;

alter system flush buffer_cache;  
SELECT   /*+ INDEX_FFS(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;

alter system flush buffer_cache;  
SELECT   /*+ INDEX_FFS(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;

alter system flush buffer_cache;  
SELECT   /*+ INDEX(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_longrow f
GROUP BY CATEGORY;

alter system flush buffer_cache;  
SELECT   /*+ INDEX(F) */
         CATEGORY, SUM (num_data)
    FROM ffs_shortrow f
GROUP BY CATEGORY;
 
EXIT;

