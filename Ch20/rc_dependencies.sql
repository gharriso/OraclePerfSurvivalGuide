rem *********************************************************** 
rem
rem	File: rc_dependencies.sql 
rem	Description: Result set cache dependencies 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 20 Page 601
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


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
