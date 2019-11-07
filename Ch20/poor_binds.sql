create or replace procedure poor_binds is 
    v_dummy number; 
begin
    for i in 1..15000000 loop 
        execute immediate 'select count(*) from txn_data where txn_id='||i into v_dummy; 
    end loop; 
end; 
