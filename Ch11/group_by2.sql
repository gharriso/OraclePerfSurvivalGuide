SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL group_by2
set arraysize 100
ALTER SESSION SET tracefile_identifier=group_by2;
ALTER SESSION SET sql_trace=TRUE;
DROP TABLE sales;

CREATE TABLE sales AS
   SELECT   * FROM sh.sales;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/

rem ALTER SESSION SET "_gby_hash_aggregation_enabled"=TRUE;

DECLARE
   t_prod_id      DBMS_SQL.number_table;
   t_quant_sold   DBMS_SQL.number_table;
BEGIN
     SELECT /* gby_hash true  */
           prod_id, SUM (quantity_sold) as gby_hash_true
       BULK   COLLECT
       INTO   t_prod_id, t_quant_sold
       FROM   sales
   GROUP BY   prod_id;
END;
/

/

DECLARE
   t_prod_id      DBMS_SQL.number_table;
   t_quant_sold   DBMS_SQL.number_table;
BEGIN
     SELECT /* gby_hash true  */
           prod_id, SUM (quantity_sold) as gby_hash_true
       BULK   COLLECT
       INTO   t_prod_id, t_quant_sold
       FROM   sales
   GROUP BY   prod_id
   ORDER BY   prod_id;
END;
/

/

ALTER SESSION SET "_gby_hash_aggregation_enabled"=FALSE;

DECLARE
   t_prod_id      DBMS_SQL.number_table;
   t_quant_sold   DBMS_SQL.number_table;
BEGIN
     SELECT /* gby_hash false  */
           prod_id, SUM (quantity_sold) as gby_hash_false
       BULK   COLLECT
       INTO   t_prod_id, t_quant_sold
       FROM   sales
   GROUP BY   prod_id;
END;
/

/

DECLARE
   t_prod_id      DBMS_SQL.number_table;
   t_quant_sold   DBMS_SQL.number_table;
BEGIN
     SELECT /* gby_hash false  */
           prod_id, SUM (quantity_sold) as gby_hash_false
       BULK   COLLECT
       INTO   t_prod_id, t_quant_sold
       FROM   sales
   GROUP BY   prod_id
   ORDER BY   prod_id;
END;
/

/

exit;
/* Formatted on 21/12/2008 8:29:31 PM (QP5 v5.120.811.25008) */
