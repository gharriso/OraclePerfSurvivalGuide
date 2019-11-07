CREATE OR REPLACE PROCEDURE big_sort(n_rows NUMBER) IS
   v_rows   NUMBER:=0;
   CURSOR c1 IS
  select * from (    select txn_id,datetime,tdata,
                      rank() over(order by tdata desc) ranking 
                       from txn_data
                      WHERE txn_id < n_rows
                      ORDER BY 3, 2, 1 ) where ranking <1000; 
   CURSOR c2 IS
      SELECT name,value
      FROM    sys.v_$mystat
           JOIN
              sys.v_$statname
           USING (statistic#)
      WHERE name LIKE '%pga%' OR name LIKE '%workarea%';
BEGIN
   FOR r IN c1 LOOP
      v_rows:=v_rows+1; 
   END LOOP;
   dbms_output.put_line('rows='||v_rows);

   FOR r2 IN c2 LOOP
      DBMS_OUTPUT.put_line(r2.name || '=' || r2.VALUE);
   END LOOP;
END; 
