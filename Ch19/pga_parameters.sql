rem *********************************************************** 
rem
rem	File: pga_parameters.sql 
rem	Description: PGA parameters and configuration from v$pgastat
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 19 Page 562
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set pagesize 1000
set lines 80
column name format a22
column description format a40
column MB format 99,999
set echo on 

SELECT ksppinm name, ksppdesc description,
       CASE WHEN ksppinm LIKE '_smm%' THEN ksppstvl/1024 
             ELSE ksppstvl/1048576 END as MB
  FROM sys.x$ksppi JOIN sys.x$ksppcv
       USING (indx)
WHERE ksppinm IN
            ('pga_aggregate_target',
             '_pga_max_size',
             '_smm_max_size',
             '_smm_px_max_size','__pga_aggregate_target' 
              ); 
             
 


