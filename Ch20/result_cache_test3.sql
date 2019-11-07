DECLARE
   v_start_date   DATE;
   v_n number:=0; 
BEGIN
   v_start_date := SYSDATE - 365 * 2;

   FOR r IN (SELECT /*+ RESULT_CACHE */ prod_name, SUM(amount_sold)
             FROM  sales
                  JOIN
                     products
                  USING (prod_id)
             WHERE time_id > v_start_date
             GROUP BY prod_name) LOOP
      v_n:=v_n+1; 
   END LOOP;
   dbms_output.put_line(v_n);
END;
/* Formatted on 2/03/2009 4:05:02 PM (QP5 v5.120.811.25008) */
