CREATE OR REPLACE PROCEDURE disk_sorts( ) IS
   v_rows   NUMBER:=1000;
   v_disk_sorts number:=0;
   v_last_disk_sorts number:=0; 
   CURSOR c1 IS
  select * from (    select txn_id,datetime,tdata,
                      rank() over(order by tdata desc) ranking 
                       from txn_data
                      WHERE txn_id < v_rows
                      ORDER BY 3, 2, 1 ) where ranking <1000; 

BEGIN
    loop 
   FOR r IN c1 LOOP
      v_rows:=v_rows+1; 
   END LOOP;
 
      SELECT sum(value) 
      into v_disk_sorts; 
      FROM    sys.v_$mystat
           JOIN
              sys.v_$statname
           USING (statistic#)
      WHERE name in ( 'workarea executions - onepass', 
      'workarea executions - multipass'); 
      if (v_disk_sorts-v_last_disk_sorts) =0 then 
      end if; 
   end loop; 
END; 
