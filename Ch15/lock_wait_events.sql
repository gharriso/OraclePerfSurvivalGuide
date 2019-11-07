rem *********************************************************** 
rem
rem	File: lock_wait_events.sql 
rem	Description: Show lock waits compared to other waits and CPU 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 15 Page 466
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on 

SELECT name
FROM v$event_name
WHERE name LIKE 'enq: TX%';
