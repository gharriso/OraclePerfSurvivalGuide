rem *********************************************************** 
rem
rem	File: blockers.sql 
rem	Description: Simple blocking locks script 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 476
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


column sql_text format a35 heading "SQL text"
column blocking_user format a8 Heading "Blocking|user"
column blocked_user format a8  heading "Blocked|user"
column blocking_sid format 9999 heading "Blocking|SID"
column blocked_sid format 9999 heading "Blocked|SID"
column type format a4 heading "Lock|Type"

set pagesize 1000
set lines 100
set echo on 

WITH sessions AS 
       (SELECT /*+ materialize*/ username,sid,sql_id
          FROM v$session),
     locks AS 
        (SELECT /*+ materialize */ *
           FROM v$lock)
SELECT l2.type,s1.username blocking_user, s1.sid blocking_sid, 
        s2.username blocked_user, s2.sid blocked_sid, sq.sql_text
  FROM locks l1
  JOIN locks l2 USING (id1, id2)
  JOIN sessions s1 ON (s1.sid = l1.sid)
  JOIN sessions s2 ON (s2.sid = l2.sid)
  LEFT OUTER JOIN  v$sql sq
       ON (sq.sql_id = s2.sql_id)
 WHERE l1.BLOCK = 1 AND l2.request > 0;

