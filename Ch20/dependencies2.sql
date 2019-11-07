SELECT  max(co.name) cached_object,count(*) result_sets_cached, do.cache_id depdendency, co.cache_id  
FROM       v$result_cache_dependency d
        JOIN
           v$result_cache_objects do
        ON (d.depend_id = do.id)
     JOIN
        v$result_cache_objects co
     ON (d.result_id = co.id)
group by do.cache_id, co.cache_id 
