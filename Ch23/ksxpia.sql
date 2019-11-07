rem *********************************************************** 
rem
rem	File: ksxpia.sql 
rem	Description: Private interconnect IP address 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 23 Page 675
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col instance_number format 999 heading "Inst|#"
col host_name format a25 heading "Host|Name"
col network_interface format a5 heading "Net|IFace"
col private_ip format a12 heading "Private|IP"
set pages 1000
set echo on 

SELECT instance_number, host_name, instance_name,
       name_ksxpia network_interface, ip_ksxpia private_ip
FROM     x$ksxpia
     CROSS JOIN
         v$instance
WHERE pub_ksxpia = 'N';
