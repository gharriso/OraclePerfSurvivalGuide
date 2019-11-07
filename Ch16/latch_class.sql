rem *********************************************************** 
rem
rem	File: latch_class.sql 
rem	Description: Adjusting spin count for an individual latch class 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 510
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on
ALTER SYSTEM SET "_SPIN_COUNT"=5000 SCOPE=BOTH;

SELECT latch#
FROM v$latch
WHERE name = 'cache buffers chains';

ALTER SYSTEM SET "_latch_classes" = "141:1" SCOPE=SPFILE;
ALTER SYSTEM SET "_latch_class_1"=10000 SCOPE=SPFILE;
 
