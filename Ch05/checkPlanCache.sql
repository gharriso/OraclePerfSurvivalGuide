rem *********************************************************** 
rem
rem	File: checkPlanCache.sql 
rem	Description: Report on indexes that are not found in any cached execution plan
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 5 Page 133
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set lines 1000
set pages 1000
set echo on 
column in_cached_plan format a16


WITH in_plan_objects AS
     (SELECT DISTINCT object_name
                 FROM v$sql_plan
                WHERE object_owner = USER)
SELECT table_name, index_name,
       CASE WHEN object_name IS NULL
            THEN 'NO'
            ELSE 'YES'
       END AS in_cached_plan
  FROM user_indexes LEFT OUTER JOIN in_plan_objects
       ON (index_name = object_name); 

