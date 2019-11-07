DECLARE
   g_prod_id         DBMS_SQL.number_table;
   g_cust_id         DBMS_SQL.number_table;
   g_time_id         DBMS_SQL.date_table;
   g_channel_id      DBMS_SQL.number_table;
   g_promo_id        DBMS_SQL.number_table;
   g_quantity_sold   DBMS_SQL.number_table;
   g_amount_sold     DBMS_SQL.number_table;
BEGIN
   SELECT prod_id, cust_id, time_id, channel_id, promo_id, quantity_sold,
          amount_sold
     BULK COLLECT
     INTO g_prod_id, g_cust_id, g_time_id, g_channel_id, g_promo_id,
          g_quantity_sold, g_amount_sold
     FROM sh.sales;
END;

SELECT * FROM sh.sales;
/* Formatted on 24/02/2009 9:55:12 AM (QP5 v5.120.811.25008) */
