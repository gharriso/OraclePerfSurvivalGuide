
create function calc_unit_cost(quantity_sold,amount_sold) return number is
begin
    return(quantity_sold/amount_sold) ;
end;
/
EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(s) */
            prod_id,
             average(calc_unit_cost(quantity_sold, amount_sold))
      FROM sales s
      GROUP BY prod_id
      ORDER BY 2 DESC;
/* Formatted on 3/01/2009 11:02:16 AM (QP5 v5.120.811.25008) */
