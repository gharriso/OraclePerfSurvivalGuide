begin
    loop
        for r in 1..400000  loop 
            for s in (select * from latency1 where txn_id=r ) loop 
                null;
            end loop;  
        end loop;
    end loop;
end;
/
