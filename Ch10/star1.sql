
SPOOL star1

alter session set tracefile_identifier=star1;
alter session set events '10053 trace name context forever, level 1'; 

SET lines 120
SET pages 10000
SET timing on
SET echo on

set autotrace on 

/* Formatted on 2008/11/15 17:10 (Formatter Plus v4.8.7) */
DROP TABLE sales;
DROP TABLE products;
DROP TABLE customers;
DROP TABLE products;
DROP TABLE times;
DROP TABLE promotions;

CREATE TABLE sales AS SELECT * FROM sh.sales;
CREATE TABLE products AS SELECT * FROM sh.products;
CREATE TABLE customers AS SELECT * FROM sh.customers;
CREATE TABLE times AS SELECT * FROM sh.times;
 
 
ALTER TABLE products ADD CONSTRAINT products_pk PRIMARY KEY (prod_id);
ALTER TABLE customers ADD CONSTRAINT customers_pk PRIMARY KEY (cust_id);
ALTER TABLE times ADD CONSTRAINT times_pk PRIMARY KEY (time_id);
 
 

CREATE INDEX cust_namedob_idx ON customers(cust_first_name,cust_last_name,cust_year_of_birth);
CREATE INDEX prod_name_idx ON products(prod_name);
CREATE INDEX times_wend_idx ON times(week_ending_day);
 

/* Formatted on 2008/11/15 17:10 (Formatter Plus v4.8.7) */
BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES' , method_opt=>'FOR ALL COLUMNS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'CUSTOMERS', method_opt=>'FOR ALL COLUMNS');
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'PRODUCTS', method_opt=>'FOR ALL COLUMNS');
 
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'TIMES', method_opt=>'FOR ALL COLUMNS');
END;
/

alter system flush buffer_cache; 

SELECT quantity_sold, amount_sold
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
 WHERE week_ending_day = to_date('29-Nov-2008','DD-MON-YYYY')
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
   and cust_year_of_birth=1965; 
 



/* Formatted on 2008/11/15 17:38 (Formatter Plus v4.8.7) */
CREATE INDEX sales_concat_idx ON sales(prod_id,time_id,cust_id);
 

alter system flush buffer_cache; 
 
SELECT quantity_sold, amount_sold
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
 WHERE week_ending_day = '29-Nov-2008'
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
     and cust_year_of_birth=1965; 
 

alter system flush buffer_cache; 

drop INDEX sales_concat_idx; 
create bitmap index sales_times_bi  on sales(time_id); 
create bitmap index sales_prod_bi  on sales(prod_id); 
create bitmap index sales_cust_bi  on sales(cust_id); 
create bitmap index sales_promo_bi  on sales(promo_id);

alter system flush buffer_cache; 

/* Formatted on 2008/11/15 17:34 (Formatter Plus v4.8.7) */
SELECT quantity_sold, amount_sold
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
 WHERE week_ending_day = '29-Nov-2008'
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
      and cust_year_of_birth=1965; 
 

alter system flush buffer_cache; 


SELECT /*+ OPT_PARAM('star_transformation_enabled' 'true') star_transformation */
       quantity_sold, amount_sold 
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
 WHERE week_ending_day = '29-Nov-2008'
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
   and cust_year_of_birth=1965; 
 
SELECT /*+ INDEX(s) */
       quantity_sold, amount_sold
  FROM sales s
 WHERE s.prod_id IN (SELECT prod_id
                       FROM products
                      WHERE prod_name = '1.44MB External 3.5" Diskette')
   AND s.time_id IN (SELECT time_id
                       FROM times
                      WHERE week_ending_day = '29-Nov-2008')
   AND s.cust_id IN (
                SELECT cust_id
                  FROM customers
                 WHERE cust_first_name = 'Hiram'
                       AND cust_last_name = 'Abbassi'
                       and cust_year_of_birth=1965  );

 
DROP INDEX cust_namedob_idx;
DROP INDEX prod_name_idx;
 
DROP INDEX times_wend_idx;
 


/* Formatted on 2008/11/16 11:24 (Formatter Plus v4.8.7) */
CREATE BITMAP INDEX sales_cust_bjix
ON sales(customers.cust_first_name,customers.cust_last_name,
            customers.cust_year_of_birth)
FROM sales, customers
WHERE sales.cust_id = customers.cust_id;


CREATE BITMAP INDEX sales_prod_bjix
ON sales(products.prod_name)
FROM sales, products
WHERE sales.prod_id=products.prod_id;  

CREATE BITMAP INDEX sales_time_bjix
ON sales(times.week_ending_day)
FROM sales, times
WHERE sales.time_id=times.time_id; 
 
alter system flush buffer_cache;

SELECT /*+ OPT_PARAM('star_transformation_enabled' 'true') star_transformation */
       quantity_sold, amount_sold 
  FROM sales s JOIN products p USING (prod_id)
       JOIN times USING (time_id)
       JOIN customers c USING (cust_id)
 WHERE week_ending_day = '29-Nov-2008'
   AND prod_name = '1.44MB External 3.5" Diskette'
   AND cust_first_name = 'Hiram'
   AND cust_last_name = 'Abbassi'
   and cust_year_of_birth=1965; 
  
EXIT; 

 

