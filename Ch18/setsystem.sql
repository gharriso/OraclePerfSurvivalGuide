alter system set "_serial_direct_read"=false scope=both;
alter system flush buffer_cache;
alter system flush shared_pool; 
alter system set shared_pool_size=200m scope=memory; 
