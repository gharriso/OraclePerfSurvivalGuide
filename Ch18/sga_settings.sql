alter system set memory_target=0 scope=both; 
alter system set sga_max_size=1600M scope=spfile; 
alter system set sga_target=1G scope=both; 
alter system set db_cache_size=0 scope=both; 
alter system set shared_pool_size=0 scope=both;
alter system set large_pool_size=0 scope=both; 
alter system set db_keep_cache_size=100m scope=both ; 
alter system set db_2k_cache_size=50m scope=both; 
select *  from v$parameter where name like '%max_size' or name like '%target' or name like '%size' ; 
select * from v$buffer_pool; 
select name,block_size/1024 block_size_kb,resize_state,current_size,prev_size from v$buffer_pool;  

select component, current_size, min_size, user_specified_size from v$sga_dynamic_components;

alter system set sga_target=800m scope=both; 
