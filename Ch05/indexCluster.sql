/* Formatted on 2008/08/21 09:24 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=intervalpartition;

SET pages 1000
SET lines 160
SET echo on
set timing on 

SPOOL IntervalPartition

BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/

DROP TABLE sales_int_test; 
CREATE TABLE sales_int_test
 (prod_id                        NUMBER NOT NULL,
    cust_id                        NUMBER NOT NULL,
    time_id                        DATE NOT NULL,
    channel_id                     NUMBER NOT NULL,
    promo_id                       NUMBER NOT NULL,
    quantity_sold                  NUMBER(10,2) NOT NULL,
    amount_sold                    NUMBER(10,2) NOT NULL)
 PARTITION BY RANGE(time_id)
 INTERVAL(numtoyminterval(1,'YEAR'))
(  PARTITION p1 VALUES LESS THAN (TO_DATE('01-jan-1995','DD-MON-RRRR')));


/* Formatted on 2008/08/21 09:55 (Formatter Plus v4.8.7) */
INSERT INTO sales_int_test
   SELECT *
     FROM sh.sales;

COMMIT ;
/* Formatted on 2008/08/21 09:55 (Formatter Plus v4.8.7) */
BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'sales_int_test'
                                 );
END;
/

rem
rem Global indexing 
rem 
set autotrace on 
/* Formatted on 2008/08/21 09:50 (Formatter Plus v4.8.7) */
CREATE INDEX sales_in_part_gi1 ON sales_int_test(promo_id);

SELECT /*+index(s,sales_in_part_gi1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33;

SELECT /*+index(s,sales_in_part_gi1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33
   AND time_id < TO_DATE ('01-JAN-1999', 'DD-MON-RRRR')
   AND time_id > TO_DATE ('01-JAN-1998', 'DD-MON-RRRR');

DROP INDEX sales_in_part_gi1;
CREATE INDEX sales_in_part_li1 ON sales_int_test(promo_id) LOCAL;

SELECT /*+index(s,sales_in_part_li1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33;

SELECT /*+index(s,sales_in_part_li1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33
   AND time_id < TO_DATE ('01-JAN-1999', 'DD-MON-RRRR')
   AND time_id > TO_DATE ('01-JAN-1998', 'DD-MON-RRRR');


DROP INDEX sales_in_part_lip1;
CREATE INDEX sales_in_part_lip1 ON sales_int_test(time_id,promo_id) LOCAL;
SELECT /*+index(s,sales_in_part_lip1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33;

SELECT /*+index(s,sales_in_part_lip1) */
       SUM (amount_sold)
  FROM sales_int_test s
 WHERE promo_id = 33
   AND time_id < TO_DATE ('01-JAN-1999', 'DD-MON-RRRR')
   AND time_id > TO_DATE ('01-JAN-1998', 'DD-MON-RRRR');


SELECT  tracefile
      FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
      WHERE audsid = USERENV ('SESSIONID'); 
      
exit; 




