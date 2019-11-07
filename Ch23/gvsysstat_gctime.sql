select name,sum(value) from gv$sysstat where name like 'gc%time%' group by name order by 2 desc  
