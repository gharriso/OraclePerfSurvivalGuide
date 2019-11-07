CREATE OR REPLACE PROCEDURE sales_sort4(iterations NUMBER) IS
   cname   sh.countries.country_name%TYPE := 'New Zealand';
   CURSOR c1 IS
      SELECT /*+ gather_plan_statistics */
             *
      FROM                   sh.sales
                         ,
                             sh.customers
                          ,
                       JOIN
                          sh.products
                       USING (prod_id)
                    JOIN
                       sh.countries
                    USING (country_id)
                 LEFT OUTER JOIN
                    sh.channels
                 USING (channel_id)
              JOIN
                 sh.times
              USING (time_id)
           LEFT OUTER JOIN
              sh.promotions
           USING (promo_id)
      WHERE country_name = cname
      ORDER BY prod_name, cust_first_name, cust_last_name, country_name;
BEGIN
   FOR i IN 1 .. iterations LOOP
      FOR r IN c1 LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
/* Formatted on 18-Mar-2009 16:40:00 (QP5 v5.120.811.25008) */
