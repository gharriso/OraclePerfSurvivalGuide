alter system set large_pool_size=0 scope=spfile; 
alter system set shared_pool_size=0 scope=spfile; 
alter system set sga_target=0 scope=spfile;
alter system set db_keep_cache_size=20M scope=spfile; 
alter system set pga_aggregate_target=0 scope=spfile; 
alter system set memory_target=1g scope=spfile; 
