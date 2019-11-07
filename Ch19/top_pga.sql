rem *********************************************************** 
rem
rem	File: top_pga.sql 
rem	Description: Top consumers of PGA memory 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 565
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pagesize 1000
set lines 100
col sid format 9999
col username format a12
col module format a30
column pga_memory_mb format 9,999.99 heading "PGA MB"
column max_pga_memory_mb format 9,999.99 heading "PGA MAX|MB"
col service name format a20 
col sql_text format a70 heading "Currently executing SQL"
set echo on 

WITH pga AS 
    (SELECT sid,
            ROUND(SUM(CASE name WHEN 'session pga memory' 
                       THEN VALUE / 1048576 END),2) pga_memory_mb,
            ROUND(SUM(CASE name WHEN 'session pga memory max' 
                      THEN VALUE / 1048576  END),2) max_pga_memory_mb
      FROM v$sesstat  
      JOIN v$statname  USING (statistic#)
     WHERE name IN ('session pga memory','session pga memory max' )
     GROUP BY sid)
SELECT sid, username,s.module, 
       pga_memory_mb, 
       max_pga_memory_mb, substr(sql_text,1,70) sql_text
  FROM v$session s
  JOIN (SELECT sid, pga_memory_mb, max_pga_memory_mb,
               RANK() OVER (ORDER BY pga_memory_mb DESC) pga_ranking
         FROM pga)
  USING (sid)
  LEFT OUTER JOIN v$sql sql 
    ON  (s.sql_id=sql.sql_id and s.sql_child_number=sql.child_number)
 WHERE pga_ranking <=5
 ORDER BY  pga_ranking
/
