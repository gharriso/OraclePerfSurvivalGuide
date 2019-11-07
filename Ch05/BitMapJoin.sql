/* Formatted on 2008/08/21 10:55 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=bitmapjoin;
SPOOL BitMapJoin

SET pages 1000
SET lines 160
SET echo on
SET timing on



BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/

DROP TABLE sales_bm;
drop table customers_bm; 
CREATE TABLE sales_bm AS SELECT * FROM sh.sales;
CREATE TABLE customers_bm AS SELECT * FROM sh.customers;
ALTER TABLE customers_bm ADD PRIMARY KEY (cust_id);
ALTER TABLE sales_bm ADD FOREIGN KEY (cust_id) REFERENCES customers_bm(cust_id);
CREATE BITMAP INDEX sales_bm_cust1 ON sales_bm(cust_id);


BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES_BM');
END;
/

SET autotrace on

SELECT SUM (amount_sold)
  FROM customers_bm JOIN sales_bm s USING (cust_id)
 WHERE cust_email='flint.jeffreys@company2.com';
 
SELECT /*+ FULL(s) */
       SUM (amount_sold)
  FROM customers_bm JOIN sales_bm s USING (cust_id)
 WHERE cust_email='flint.jeffreys@company2.com';

SELECT /*+ ORDERED INDEX(s,sales_bm_promo1) */
       SUM (amount_sold)
  FROM customers_bm JOIN sales_bm s USING (cust_id)
 WHERE cust_email='flint.jeffreys@company2.com';

CREATE  BITMAP INDEX sales_bm_join_i 
    ON sales_bm(c.cust_email)
  FROM  sales_bm  s , customers_bm c
 WHERE s.cust_id=c.cust_id;

SELECT /*+ INDEX(s,sales_bm_join_i) */
       SUM (amount_sold)
  FROM customers_bm JOIN sales_bm s USING (cust_id)
 WHERE cust_email='flint.jeffreys@company2.com';


DROP INDEX sales_bm_join_i;

SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

