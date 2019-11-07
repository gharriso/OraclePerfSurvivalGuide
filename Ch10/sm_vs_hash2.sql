/* Formatted on 2008/11/06 11:56 (Formatter Plus v4.8.7) */
SPOOL sm_vs_hash2


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=sm_vs_hash;

DROP TABLE price_cat;
CREATE TABLE price_cat (low_price NUMBER, high_price NUMBER, price_cat VARCHAR2(1000));

REM drop table sales;
CREATE TABLE sales AS SELECT * FROM sh.sales;

DECLARE
   i   NUMBER;
   j   NUMBER;
   k   NUMBER;
BEGIN
   j := 0;
   i := .49;
   k := 1;

   WHILE j < 50000
   LOOP
      INSERT INTO price_cat
           VALUES (j, j + i, 'category ' || k);

      j := j + i + .01;
      k := k + 1;
   END LOOP;

   COMMIT;
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'PRICE_CAT');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/
set autotrace on 

SELECT max(price_cat) ,max(amount_sold)
  FROM sales s JOIN price_cat c
       ON (s.amount_sold BETWEEN c.low_price AND c.high_price)
       ;
exit;
