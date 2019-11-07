/* Formatted on 2008/08/20 21:53 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=BitMapMerge;
SPOOL BitMapMerge

SET pages 1000
SET lines 160
SET echo on
set timing on 

SPOOL BitMapMerge

BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/

DROP TABLE sales_bm_test;
CREATE TABLE sales_bm_test
 (prod_id                        NUMBER NOT NULL,
    cust_id                        NUMBER NOT NULL,
    time_id                        DATE NOT NULL,
    channel_id                     NUMBER NOT NULL,
    promo_id                       NUMBER NOT NULL,
    quantity_sold                  NUMBER(10,2) NOT NULL,
    amount_sold                    NUMBER(10,2) NOT NULL);


INSERT INTO sales_bm_test
   SELECT *
     FROM sh.sales;
COMMIT ;

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES_BM_TEST');
END;
/

REM
REM Global indexing
REM
SET autotrace on

SELECT /*+FULL(s) */
       SUM (amount_sold)
  FROM sales_bm_test s
 WHERE prod_id = 140 AND cust_id = 665 AND channel_id = 3 AND promo_id = 999;
SELECT /*+FULL(s) */
       SUM (amount_sold)
  FROM sales_bm_test s
 WHERE prod_id = 140 AND cust_id = 665 AND channel_id = 3 AND promo_id = 999;
CREATE INDEX smc ON sales_bm_test(prod_id,cust_id,channel_id,promo_id);
SELECT /*+INDEX(s,smc)*/
       SUM (amount_sold)
  FROM sales_bm_test s
 WHERE prod_id = 140 AND cust_id = 665 AND channel_id = 3 AND promo_id = 999;
DROP INDEX smc;
CREATE INDEX smc1 ON sales_bm_test(prod_id);
CREATE INDEX smc2 ON sales_bm_test(cust_id);
CREATE INDEX smc3 ON sales_bm_test(channel_id);
CREATE INDEX smc4 ON sales_bm_test(promo_id);


SELECT /*+ AND_EQUAL(s,smc1,smc2,smc3,smc4) */
       SUM (amount_sold)
  FROM sales_bm_test s
 WHERE prod_id = 140 AND cust_id = 665 AND channel_id = 3 AND promo_id = 999;

drop index smc1;
drop index smc2;
drop index smc3;
drop index smc4;
CREATE BITMAP INDEX smb1 ON sales_bm_test(prod_id);
CREATE  BITMAP INDEX smb2 ON sales_bm_test(cust_id);
CREATE  BITMAP INDEX smb3 ON sales_bm_test(channel_id);
CREATE  BITMAP INDEX smb4 ON sales_bm_test(promo_id);

SELECT /*+ AND_EQUAL(s,smb1,smb2,smb3,smb4) */
       SUM (amount_sold)
  FROM sales_bm_test s
 WHERE prod_id = 140 AND cust_id = 665 AND channel_id = 3 AND promo_id = 999;

SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

