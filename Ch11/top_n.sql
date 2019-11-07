/* Formatted on 2008/11/29 12:05 (Formatter Plus v4.8.7) */
SET lines 200
SET pages 10000
SET echo on
SET timing on
SPOOL top_n

ALTER SESSION SET tracefile_identifier=top_n;
ALTER SESSION SET sql_trace=TRUE;

 TABLE sales;
CREATE TABLE sales AS  
SELECT a.prod_id, a.cust_id, a.time_id, a.channel_id, a.promo_id,
       a.quantity_sold * DBMS_RANDOM.VALUE (0, 2) quantity_sold,
       a.amount_sold * DBMS_RANDOM.VALUE (0, 2) amount_sold
  FROM sh.sales a;

/*insert into sales 
SELECT a.prod_id, a.cust_id, a.time_id, a.channel_id, a.promo_id,
       a.quantity_sold * DBMS_RANDOM.VALUE (0, 2) quantity_sold,
       a.amount_sold * DBMS_RANDOM.VALUE (0, 2) amount_sold
  FROM sh.sales a;  */

commit; 

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'SALES'
); 


END;
/



SELECT   *
    FROM sales
   WHERE ROWNUM < 10
ORDER BY amount_sold DESC;

alter system flush shared_pool;

set autotrace on 

SELECT /* top10 subquery */ *
  FROM (SELECT   cust_id, prod_id, time_id, amount_sold
            FROM sales
        ORDER BY amount_sold DESC)
 WHERE ROWNUM < 10;

alter system flush buffer_cache; 

set autotrace on 

SELECT /* top10 dense_rank*/ *
  FROM (SELECT cust_id, prod_id, time_id, amount_sold,
               DENSE_RANK () OVER (ORDER BY amount_sold DESC) ranking
          FROM sales)
 WHERE ranking < 10; 
 
set autotrace off 
 
alter system flush buffer_cache; 

alter system flush buffer_cache; 

set autotrace on 

SELECT /* top10 rank*/ *
  FROM (SELECT cust_id, prod_id, time_id, amount_sold,
                RANK () OVER (ORDER BY amount_sold DESC) ranking
          FROM sales)
 WHERE ranking < 10; 
 
set autotrace off 
 
alter system flush buffer_cache; 
 
var v_sql_id varchar2(13)
var v_child_number number 
 
 

SELECT sql_id, SUBSTR (sql_text, 1, 50), active_time, estimated_optimal_size,
       estimated_onepass_size, last_memory_used
  FROM v$sql JOIN v$sql_workarea USING (sql_id, child_number)
 WHERE sql_text LIKE '%top10%' AND sql_text NOT LIKE '%v$sql%';

SET autotrace off
set timing off
    
 
BEGIN
   SELECT sql_id, child_number
     INTO :v_sql_id, :v_child_number
     FROM v$sql  
    WHERE sql_text LIKE 'SELECT%top10 dense_rank%' AND sql_text NOT LIKE '%v$sql%'   ;
END;
/
select * from table(dbms_xplan.display_cursor(:v_sql_id,:v_child_number, 'MEMSTATS'));
select * from table(dbms_xplan.display_cursor(:v_sql_id,:v_child_number, 'TYPICAL'));

BEGIN
   SELECT sql_id, child_number
     INTO :v_sql_id, :v_child_number
     FROM v$sql  
    WHERE sql_text LIKE 'SELECT%top10 subquery%' AND sql_text NOT LIKE '%v$sql%'   ;
END;
/
select * from table(dbms_xplan.display_cursor(:v_sql_id,:v_child_number, 'MEMSTATS'));
select * from table(dbms_xplan.display_cursor(:v_sql_id,:v_child_number, 'TYPICAL'));


 
 
 exit; 

