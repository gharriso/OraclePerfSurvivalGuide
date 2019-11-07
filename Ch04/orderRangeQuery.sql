/* Formatted on 2008/08/31 16:49 (Formatter Plus v4.8.7) */
alter system set result_cache_mode='MANUAL' scope=both; 
DROP TABLE raw_sales;

CREATE TABLE raw_sales AS
 SELECT * FROM sh.sales;

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'RAW_SALES');
END;
/
 
DECLARE
   v_sqltext   VARCHAR2 (2000);
   v_year      VARCHAR2 (2000);
   v_totals    NUMBER;
BEGIN
   FOR i IN 1 .. 100
   LOOP
      FOR v_year IN 1998 .. 2008
      LOOP
         v_sqltext :=
               'SELECT SUM(AMOUNT_SOLD) FROM raw_sales '
            || 'WHERE time_id > ''01-JAN-'
            || v_year
            || ''' AND time_id < ''31-DEC-'
            || v_year
            || '''';

         EXECUTE IMMEDIATE v_sqltext
                      INTO v_totals;
      END LOOP;
   END LOOP;
END;
/

