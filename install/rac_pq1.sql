SELECT   /*+ parallel(sa,12) */
         prod_id, quantity_sold, amount_sold
    FROM sales_archive sa
ORDER BY 1, 2, 3;
select * from v$pq_tqstat;  
