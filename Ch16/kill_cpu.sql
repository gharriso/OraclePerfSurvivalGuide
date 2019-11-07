create table kill_cpu (n, primary key(n)) organization index
as
select rownum n
from all_objects
where rownum <= 23
;

select count(*) X
from kill_cpu
connect by n > prior n
start with n = 1
; 
