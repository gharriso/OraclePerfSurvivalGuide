begin 
    for r in (select rowid from txn_summary ) loop
        for r1 in (select * from txn_summary where rowid=r.rowid) loop
            null;
        end loop; 
    end loop; 
end; 
/
