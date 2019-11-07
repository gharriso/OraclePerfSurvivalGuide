/* Formatted on 2008/11/04 22:14 (Formatter Plus v4.8.7) */
SPOOL expres


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=expres;
ALTER SESSION SET sql_trace= TRUE;


 DROP  TABLE sales;

CREATE TABLE sales   AS SELECT * FROM sh.sales;

CREATE OR REPLACE FUNCTION sale_category (p_amount_sold NUMBER)
   RETURN NUMBER DETERMINISTIC
IS
   v_sale_category   NUMBER;
BEGIN
   IF p_amount_sold > 1000
   THEN
      v_sale_category := 2;
   ELSIF p_amount_sold > 10000
   THEN
      v_sale_category := 3;
   ELSIF p_amount_sold > 100000
   THEN
      v_sale_category := 4;
   ELSE
      v_sale_category := 1;
   END IF;

   RETURN (v_sale_category);
END;
/

CREATE INDEX sales_i1 ON sales  (sale_category(amount_sold));

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/

SET autotrace on

SELECT COUNT (*), SUM (amount_sold)
  FROM sales
 WHERE sale_category (amount_sold) = 1;


BEGIN
   DBMS_STATS.gather_table_stats
      (ownname         => USER,
       tabname         => 'SALES',
       method_opt      => 'FOR ALL COLUMNS FOR COLUMNS (sale_category(amount_sold))'
      );
END;
/

SELECT COUNT (*), SUM (amount_sold)
  FROM sales
 WHERE sale_category (amount_sold) = 1;

EXIT

