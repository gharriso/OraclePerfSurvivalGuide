rem *********************************************************** 
rem
rem	File: px_session.sql 
rem	Description: Show real time view of current parallel executions 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 13 Page 414
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on

WITH px_session AS (  SELECT   qcsid, qcserial#, MAX (degree) degree,
                               MAX (req_degree) req_degree,
                               COUNT ( * ) no_of_processes
                        FROM   v$px_session p
                    GROUP BY   qcsid, qcserial#)
SELECT   s.sid, s.username, degree, req_degree, no_of_processes, 
         sql_text
  FROM   v$session s  JOIN px_session p
           ON (s.sid = p.qcsid AND s.serial# = p.qcserial#)
         JOIN v$sql sql
           ON (sql.sql_id = s.sql_id 
               AND sql.child_number = s.sql_child_number)
/

/* Formatted on 30/12/2008 5:43:12 PM (QP5 v5.120.811.25008) */
