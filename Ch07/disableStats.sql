rem *********************************************************** 
rem
rem	File: disableStats.sql
rem	Description: Disable automatic statistics collection
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 7 Page 198
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


BEGIN
   dbms_auto_task_admin.disable
             (client_name=> 'auto optimizer stats collection',
              operation        => NULL,
              window_name      => NULL
             );
END;
