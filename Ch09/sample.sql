/* Formatted on 2008/11/02 17:33 (Formatter Plus v4.8.7) */
SPOOL sample


SET lines 120
SET pages 10000
SET timing on
SET echo on

ALTER SESSION SET tracefile_identifier=SAMPLE;

ALTER SESSION SET sql_trace= TRUE;

SET autotrace on

WITH sales_totals AS
     (
        SELECT   prod_name,
                 ROUND (SUM (amount_sold) * 100
                        / SUM (SUM (amount_sold)) OVER (),
                        2
                       ) pct_amount,
                 RANK () OVER (ORDER BY SUM (amount_sold) DESC) ranking
            FROM sh.sales JOIN sh.products USING (prod_id)
        GROUP BY prod_name)
SELECT   prod_name, pct_amount
    FROM sales_totals
   WHERE ranking <= 5
ORDER BY pct_amount DESC;

WITH sales_totals_sampled AS
     (
        SELECT   prod_name,
                 ROUND (SUM (amount_sold) * 100
                        / SUM (SUM (amount_sold)) OVER (),
                        2
                       ) pct_amount,
                 RANK () OVER (ORDER BY SUM (amount_sold) DESC) ranking
            FROM sh.sales SAMPLE BLOCK (10) JOIN sh.products USING (prod_id)
        GROUP BY prod_name)
SELECT   prod_name, pct_amount
    FROM sales_totals_sampled
   WHERE ranking <= 5
ORDER BY pct_amount DESC;

SET autotrace off

WITH sales_totals_sampled AS
     (
        SELECT   prod_name,
                 ROUND (SUM (amount_sold) * 100
                        / SUM (SUM (amount_sold)) OVER (),
                        2
                       ) pct_amount,
                 RANK () OVER (ORDER BY SUM (amount_sold) DESC) ranking
            FROM sh.sales SAMPLE BLOCK (10) JOIN sh.products USING (prod_id)
        GROUP BY prod_name),
     sales_totals AS
     (
        SELECT   prod_name,
                 ROUND (SUM (amount_sold) * 100
                        / SUM (SUM (amount_sold)) OVER (),
                        2
                       ) pct_amount,
                 RANK () OVER (ORDER BY SUM (amount_sold) DESC) ranking
            FROM sh.sales JOIN sh.products USING (prod_id)
        GROUP BY prod_name)
SELECT   prod_name, s.pct_amount "Pct (actual)",
         samp.pct_amount "Pct (sampled)",
         ROUND((s.pct_amount-samp.pct_amount)*100/s.pct_amount,2) "Pct Difference"
    FROM sales_totals s LEFT OUTER JOIN sales_totals_sampled samp USING (prod_name)
   WHERE s.ranking <= 5
ORDER BY s.pct_amount DESC;

exit;

