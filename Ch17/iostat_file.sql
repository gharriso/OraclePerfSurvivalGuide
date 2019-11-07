rem *********************************************************** 
rem
rem	File: iostat_file.sql 
rem	Description: Status of ansynchronous IO 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 17 Page 519
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set echo on 

SELECT asynch_io, COUNT( * )
FROM v$iostat_file
WHERE filetype_name in ( 'Data File','Temp File')
GROUP BY asynch_io
/

