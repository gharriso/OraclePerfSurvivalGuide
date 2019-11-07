create or replace procedure do_updates (p_iterations number) is 
    v_txn_id number; 
begin  
    for i in 1..p_iterations loop
        v_txn_id:=round(dbms_random.value(1,1000000)); 
        begin
            update txn_data set datetime=sysdate where txn_id=v_txn_id; 
            commit; 
        exception when no_data_found then null;
        end ; 
    end loop ; 
end; 
