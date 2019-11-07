spool pqo_io
ALTER SESSION SET tracefile_identifier=pqo_balance;
rem ALTER SESSION SET events '10046 trace name context forever, level 8';
set pagesize 1000
set lines 120
set echo on
set timing on
col stat_name format a20
DROP TABLE sales;
CREATE TABLE sales AS
   SELECT   * FROM sh.sales;
INSERT INTO sales
   SELECT   *
     FROM   sales
    WHERE   time_id > SYSDATE - 365;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES');
END;
/
EXPLAIN PLAN
   FOR
        SELECT /*+ parallel(s,2) */
              to_char(time_id,'YYYY'), SUM (amount_sold)
          FROM   sales s
      GROUP BY   to_char(time_id,'YYYY')
      ORDER BY   to_char(time_id,'YYYY');
SELECT   * FROM table (DBMS_XPLAN.display ());

BEGIN
   FOR r IN (  SELECT /*+ parallel(s,2) */
                     to_char(time_id,'YYYY'), SUM (amount_sold)
                 FROM   sales s
             GROUP BY   to_char(time_id,'YYYY')
             ORDER BY   to_char(time_id,'YYYY')) LOOP
      NULL;
   END LOOP;
END;
/
  SELECT   ':TQ1' || LTRIM (TO_CHAR (tq_id, '000')) object_node, server_type,
           AVG (num_rows) avg_rows, MIN (num_rows) min_rows,
           MAX (num_rows) max_rows, COUNT ( * ) actual_dop
    FROM   v$pq_tqstat t
   WHERE   dfo_number = (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
GROUP BY   tq_id, server_type
ORDER BY   1, 2 DESC;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALES',
   method_opt => 'FOR ALL COLUMNS FOR COLUMNS  (to_char(time_id,''YYYY''))'
);
END;
/

BEGIN
   FOR r IN (  SELECT /*+ parallel(s,2) */
                     to_char(time_id,'YYYY'), SUM (amount_sold)
                 FROM   sales s
             GROUP BY   to_char(time_id,'YYYY')
             ORDER BY   to_char(time_id,'YYYY')) LOOP
      NULL;
   END LOOP;
END;
/
SELECT   *
  FROM   v$pq_tqstat
 WHERE   dfo_number = (SELECT   MAX (dfo_number) FROM v$pq_tqstat);

  SELECT   ':TQ1' || LTRIM (TO_CHAR (tq_id, '000')) object_node, server_type,
           AVG (num_rows) avg_rows, MIN (num_rows) min_rows,
           MAX (num_rows) max_rows, COUNT ( * ) actual_dop
    FROM   v$pq_tqstat t
   WHERE   dfo_number = (  SELECT   MAX (dfo_number) FROM v$pq_tqstat)
GROUP BY   tq_id, server_type
ORDER BY   1, 2 DESC;
exit;
/* Formatted on 27/12/2008 8:52:59 PM (QP5 v5.120.811.25008) */
