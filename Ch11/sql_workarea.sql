rem *********************************************************** 
rem
rem	File: sql_workarea.sql 
rem	Description: Show statistics onsort and hash workareas (from V$SQL_WORKAREA)  
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 11 Page 332
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


/* Formatted on 2008/11/24 16:43 (Formatter Plus v4.8.7) */
set pages 1000
set lines 66
SET RECSEP WRAPPED
SET RECSEPCHAR "-"
column seconds format 9999.99
 
column "O/1/M" format a8
column "SQL ID - CHILD" format a16
column sql_text format a66 
set echo on

WITH sql_workarea AS
     (
        SELECT sql_id || '-' || child_number SQL_ID_Child, 
           operation_type operation ,
           last_execution last_exec,
           ROUND (active_time / 1000000,
                          2) seconds,
           optimal_executions || '/'
            || onepass_executions || '/'
            || multipasses_executions o1m,
            '    ' || SUBSTR (sql_text, 1, 155) sql_text,
           RANK () OVER (ORDER BY active_time DESC) ranking
        FROM v$sql_workarea JOIN v$sql 
             USING (sql_id, child_number)  )
SELECT   sql_id_child "SQL ID - CHILD",seconds,operation,
        last_exec,  o1m "O/1/M",sql_text
    FROM sql_workarea
   WHERE ranking <= 2
ORDER BY ranking;
