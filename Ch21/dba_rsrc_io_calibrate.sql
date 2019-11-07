rem *********************************************************** 
rem
rem	File: dba_rsrc_io_calibrate.sql 
rem	Description: Query IO calibration data 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 625
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col max_iops heading "Max |IO/Sec"
col max_mbps heading "Max|MB/Sec"
col Max_pmbps heading "Max MB/Sec|Single Proc" 
col latency heading "Latency|ms"
col num_physical_disks heading "Num of|Phys Disks" 

SELECT max_iops, max_mbps, max_pmbps, latency, 
       num_physical_disks
  FROM dba_rsrc_io_calibrate; 
