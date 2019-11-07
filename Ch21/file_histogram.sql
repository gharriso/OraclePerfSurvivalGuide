rem *********************************************************** 
rem
rem	File: file_histogram.sql 
rem	Description: IO service time histogram 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 623
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col read_time format a9 heading "Read Time|(ms)"
col reads format 99,999,999 heading "Reads"
col histogram format a51 heading ""
set pagesize 10000
set lines 100 
set echo on 

SELECT LAG(singleblkrdtim_milli, 1) 
         OVER (ORDER BY singleblkrdtim_milli) 
          || '<' || singleblkrdtim_milli read_time, 
       SUM(singleblkrds) reads,
       RPAD(' ', ROUND(SUM(singleblkrds) * 50 / 
         MAX(SUM(singleblkrds)) OVER ()), '*')  histogram
FROM v$file_histogram
GROUP BY singleblkrdtim_milli
ORDER BY singleblkrdtim_milli; 
