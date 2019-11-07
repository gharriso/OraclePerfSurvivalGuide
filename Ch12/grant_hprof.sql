select 'create public synonym '||object_name ||' for sys.'||object_name||';' from all_objects where object_name like 'DBMSHP%'

create public synonym DBMSHP_RUNS for sys.DBMSHP_RUNS;                          
create public synonym DBMSHP_RUNNUMBER for sys.DBMSHP_RUNNUMBER;                
create public synonym DBMSHP_PARENT_CHILD_INFO for sys.DBMSHP_PARENT_CHILD_INFO;
create public synonym DBMSHP_FUNCTION_INFO for sys.DBMSHP_FUNCTION_INFO;        
