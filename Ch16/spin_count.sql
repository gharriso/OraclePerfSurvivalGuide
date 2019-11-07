alter system set db_cache_advice=off scope=memory; 
alter system set "_spin_count"=&1 scope=memory ;
alter system set RESOURCE_MANAGER_PLAN=null scope=memory; 
alter system set RESOURCE_MANAGER_CPU_ALLOCATION=20 scope=memory; 
exit;
