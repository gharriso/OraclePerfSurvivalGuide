alter session set tracefile_identifier=fk_test; 
alter session set events '10046 trace name context forever, level 8';

begin
    for i in 1..1000 loop 
        for r in (select rowid,quantity_sold from sales where cust_id=987 for update) loop
           update sales set quantity_sold=r.quantity_sold where rowid=r.rowid;
        end loop;
        commit; 
    end loop;
end; 
/
select event,time_waited_micro from v$session_event where wait_class<> 'Idle' 
 and sid in (select sid from v$session where audsid=userenv('sessionid'))
order by time_waited_micro desc
 ;

