declare
    t_deltas pqo_test.osstat_typ;
    v_stat_name varchar2(1000); 
    
begin
    t_deltas:=pqo_test.ostats_deltas(); 
     v_stat_name := t_deltas.FIRST ();

         WHILE (v_stat_name IS NOT NULL) LOOP
            dbms_output.put_line(v_stat_name||' '||t_deltas(v_stat_name));  
            v_stat_name := t_deltas.NEXT (v_stat_name);
         END LOOP;
end; 
