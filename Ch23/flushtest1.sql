declare
    i number:=1; 
begin
    loop
        update latency1 set datetime=sysdate;
        i:=i+1; 
        if (mod(i,100)=0) then 
            commit; 
        end if;
    end loop;
end; 
/
    
