
alter system set db_cache_size=500M scope=both;

alter system set db_keep_cache_size=100M scope=both;
ALTER TABLE TXN_SUMMARY  STORAGE (BUFFER_POOL default);

alter system flush buffer_cache ; 
alter system flush shared_pool;
 
