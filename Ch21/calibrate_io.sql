rem *********************************************************** 
rem
rem	File: calibrate_io.sql 
rem	Description: PL/SQL reoutine to calibrate IO 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 624
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set serveroutput on
set echo on

DECLARE
   v_max_iops         NUMBER;
   v_max_mbps         NUMBER;
   v_actual_latency   NUMBER;
BEGIN
   DBMS_RESOURCE_MANAGER.calibrate_io(
        num_physical_disks => 8,
        max_latency => 10, 
        max_iops => v_max_iops, 
        max_mbps => v_max_mbps,
        actual_latency => v_actual_latency);
        
   DBMS_OUTPUT.put_line('Max IOPS=' || v_max_iops);
   DBMS_OUTPUT.put_line('Max MBps=' || v_max_mbps);
   DBMS_OUTPUT.put_line('Latency =' || v_actual_latency);
   
END;
/
