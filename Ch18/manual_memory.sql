atler
alter system set memory_target=0 scope=memory; 
alter system set sga_target=0 scope=memory; 
alter system set db_cache_size=200m; 

select * from v$parameter where name like '%cache%'
