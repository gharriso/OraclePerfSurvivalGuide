/* Formatted on 2008/09/10 17:05 (Formatter Plus v4.8.7) */
SELECT   cust_last_name, SUM (quantity_sold)
    FROM sh.sales s JOIN sh.customers USING (cust_id)
   WHERE time_id > SYSDATE - NUMTOYMINTERVAL (1, 'YEAR')
GROUP BY cust_last_name
ORDER BY 2 DESC

