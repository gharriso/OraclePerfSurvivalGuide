rem *********************************************************** 
rem
rem	File: latch_class_qry.sql 
rem	Description: Query to show latch class configuration 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 16 Page 511
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on
column latch_name format a30
 
SELECT kslltnam latch_name, class_ksllt latch_class, 
       c.spin class_spin_count
  FROM x$kslltr r JOIN x$ksllclass c
    ON (c.indx = r.class_ksllt)
 WHERE r.class_ksllt > 0; 

