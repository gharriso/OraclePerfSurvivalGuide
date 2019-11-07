spool pqo_io
ALTER SESSION SET tracefile_identifier=pqo_io2;
ALTER SESSION SET events '10046 trace name context forever, level 8'; 
set pagesize 1000
set lines 120
set echo on
set timing on
col stat_name format a20 

DROP TABLE sales;
CREATE TABLE sales AS
   SELECT   * FROM sh.sales;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/
   
begin
    dbms_session.set_identifier('PQO_IO'); 
end; 
/


BEGIN
   FOR i IN 1 .. 1 LOOP
      INSERT INTO sales
           SELECT   * FROM sh.sales;
   END LOOP;
END;
/
COMMIT;

CREATE or replace  VIEW top5_waits_view AS
   SELECT   *
     FROM   (SELECT   stat_name, sample_seconds,
                      waits_per_second * sample_seconds waits,
                      microseconds_per_second * sample_seconds micro_wait,
                      RANK () OVER (ORDER BY microseconds_per_second DESC) ranking,
                      ROUND (  microseconds_per_second
                             * 100
                             / SUM (microseconds_per_second) OVER (), 2)
                         pct
               FROM   opsg_delta_report)
    WHERE   ranking <= 5;
    
SELECT   * FROM top5_waits_view;


DECLARE
   t_prods    DBMS_SQL.number_table;
   t_counts   DBMS_SQL.number_table;
BEGIN
   -- EXECUTE IMMEDIATE 'alter system flush buffer_cache';
     SELECT /*+ no_parallel */
           prod_id, MAX(amount_sold) 
       BULK   COLLECT
       INTO   t_prods, t_counts
       FROM   sales s
   GROUP BY   prod_id;
   DBMS_LOCK.sleep (10);
END;
/

SELECT   * FROM top5_waits_view;


DECLARE
   t_prods    DBMS_SQL.number_table;
   t_counts   DBMS_SQL.number_table;
BEGIN
   -- EXECUTE IMMEDIATE 'alter system flush buffer_cache';
     SELECT   /*+ parallel(s,8) */ prod_id, SUM(amount_sold)
       BULK   COLLECT
       INTO   t_prods, t_counts
       FROM   sales s
   GROUP BY   prod_id;
   DBMS_LOCK.sleep (10);
END;
/

SELECT   * FROM top5_waits_view;
 
exit; 
