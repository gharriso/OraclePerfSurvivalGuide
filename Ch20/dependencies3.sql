column cached_object format a40
column result_sets_cached format 99,999 heading "No of|Result Sets"
column dependency format a20 heading "Dependent|Object"
break on cached_object on result_sets_cached skip 1
set pages 1000
set lines 80
set echo on 

SELECT /*+ ordered */ max(co.name) cached_object,
       count(*) result_sets_cached, do.cache_id dependency   
FROM       v$result_cache_dependency d
        JOIN
           v$result_cache_objects do
        ON (d.depend_id = do.id)
     JOIN
        v$result_cache_objects co
     ON (d.result_id = co.id)
group by do.cache_id, co.cache_id 
order by cached_object;  
