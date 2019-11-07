select * from v$session_event e join v$session using (sid) where program like '%ARC%' and e.wait_class <> 'Idle'  order by time_waited desc 
