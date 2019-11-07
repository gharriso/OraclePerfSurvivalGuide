/* Formatted on 2008/11/03 10:55 (Formatter Plus v4.8.7) */
SPOOL partition1


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=partition1;

ALTER SESSION SET sql_trace= TRUE;

REM DROP TABLE unpartitioned_sales;
CREATE TABLE unpartitioned_sales AS SELECT * FROM sh.sales;
CREATE INDEX unpartitioned_sales_i1 ON unpartitioned_sales (time_id);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'UNPARTITIONED_SALES');

END;
/
VAR yearsBack number;

BEGIN
   :yearsback := 2;
END;
/

SET autotrace on

alter system flush buffer_cache; 
SELECT /*+ FULL(S) */MAX (amount_sold)
  FROM sh.sales s
 WHERE time_id > SYSDATE - NUMTOYMINTERVAL (:yearsback, 'year');
 
alter system flush buffer_cache; 
SELECT /*+ FULL(s) */
       MAX (amount_sold)
  FROM unpartitioned_sales s
 WHERE time_id > SYSDATE - NUMTOYMINTERVAL (:yearsback, 'year');
 
alter system flush buffer_cache; 
SELECT /*+ INDEX(s) */
       MAX (amount_sold)
  FROM unpartitioned_sales s
 WHERE time_id > SYSDATE - NUMTOYMINTERVAL (:yearsback, 'year');

EXIT;

