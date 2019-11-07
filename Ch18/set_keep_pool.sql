
alter system set db_cache_size=550M scope=both;

alter system set db_keep_cache_size=50M scope=both;
ALTER TABLE TXN_SUMMARY  STORAGE (BUFFER_POOL KEEP);

alter system flush buffer_cache ; 
 
