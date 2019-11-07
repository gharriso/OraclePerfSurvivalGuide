rem *********************************************************** 
rem
rem	File: monitoringOn.sql 
rem	Description: Turn on monitoring for all indexes
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 5 Page 122
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


 
BEGIN
   FOR r IN (SELECT index_name
               FROM user_indexes)
   LOOP
      EXECUTE IMMEDIATE 'ALTER INDEX ' || r.index_name || 
        ' MONITORING USAGE';
   END LOOP;
END;

