select name,value from v$pgastat where name in ('aggregate PGA auto target','total PGA allocated')
union
select 'sga size',sum(bytes) from v$sgastat
