rem *********************************************************** 
rem
rem	File: rac_pqo2.sql 
rem	Description: Example of using v$pq_tqstat to show inster-instance parallel in RAC 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 13 Page 422
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


spool rac_pqo2
set echo on
set pagesize 1000
set lines 120
set timing on
DROP TABLE sales;
CREATE TABLE sales AS
   SELECT   * FROM sh.sales;
SELECT   *
