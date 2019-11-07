set echo on 
col event format a20 
set serveroutput on 
exec big_sort(&1)
select * from my_wait_view; 
