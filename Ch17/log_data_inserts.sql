declare 
    t_id dbms_sql.number_type;
    t_datetime dbms_sql.date_type;
    t_data dbms_sql.varchar_type; 
    v_start_id number; 
begin
    select max(id) into v_start_id from log_data; 
    for i in 1..1000 loop
        t_id(i):=v_start_id+1;
        t_datetime(i):=sysdate-dbms_random.value(1,1000);   
        t_data(i):=t_datetime(i)||rpad('x',800,'x'); 
    end loop; 
    forall i in 1..1000
        insert into log_data (id,datetime,data)
         values(t_id(i),t_datetime(i),t_data(i)); 
end; 
    

