rem *********************************************************** 
rem
rem	File: force_matching.sql 
rem	Description: Identify SQLs that are identical other than for literal values (Force matching candidates)
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 6 Page 157
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pages 1000
set lines 100
set echo on 

column schema format a20
column sql_text format a80 
WITH force_matches AS
       (SELECT force_matching_signature,
               COUNT( * )  matches,
               MAX(sql_id || child_number) max_sql_child,
               DENSE_RANK() OVER (ORDER BY COUNT( * ) DESC)
                  ranking
        FROM v$sql
        WHERE force_matching_signature <> 0
          AND parsing_schema_name <> 'SYS'
        GROUP BY force_matching_signature
        HAVING COUNT( * ) > 5)
SELECT sql_id,  matches, parsing_schema_name schema, sql_text
  FROM    v$sql JOIN force_matches
    ON (sql_id || child_number = max_sql_child)
WHERE ranking <= 10
ORDER BY matches DESC; 

