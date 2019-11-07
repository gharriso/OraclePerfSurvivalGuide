rem *********************************************************** 
rem
rem	File: topsql1.sql 
rem	Description: Top 10 cached sql statements by elapsed time 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 3 Page 41
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


/* Formatted on 2008/07/19 14:21 (Formatter Plus v4.8.7) */
SELECT sql_id,child_number,sql_text, elapsed_time 
  FROM (SELECT sql_id, child_number, sql_text, elapsed_time, cpu_time,
               disk_reads,
               RANK () OVER (ORDER BY elapsed_time DESC) AS elapsed_rank
          FROM v$sql)
 WHERE elapsed_rank <= 10

