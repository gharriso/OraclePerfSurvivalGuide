alter session set tracefile_identifier=star2;
alter session set sql_trace=true; 
alter session set events '10053 trace name context forever, level 1'; 

SELECT /*+ OPT_PARAM('star_transformation_enabled' 'true') */
       quantity_sold, amount_sold
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
       JOIN promotions USING (promo_id)
 WHERE week_ending_day = '29-Nov-2008'
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
   AND promo_name = 'NO PROMOTION #';
   
 SELECT quantity_sold, amount_sold
  FROM sales s
 WHERE s.prod_id IN
       (SELECT prod_id
          FROM products
         WHERE prod_name = '1.44MB External 3.5" Diskette')
   AND s.time_id IN
       (SELECT time_id
          FROM times
         WHERE week_ending_day = '29-Nov-2008')
   AND s.cust_id IN
       (SELECT cust_id
          FROM customers
         WHERE cust_first_name = 'Hiram'
           AND cust_last_name = 'Abbassi')
   AND s.promo_id IN
       (SELECT promo_id 
          FROM promotions
         WHERE promo_name = 'NO PROMOTION #'); 
  

exit; 
