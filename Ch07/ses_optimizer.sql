rem *********************************************************** 
rem
rem	File: ses_optimizer.sql 
rem	Description: Show optimizer parameters in effect for the curren session 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 7 Page 194
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


set lines 82
set pages 1000
col name format a30 
col isdefault format a7 heading "Default"
col value format a40
col description format a70
set echo on 
 
SELECT   NAME, e.isdefault, e.VALUE, p.description
    FROM v$ses_optimizer_env e LEFT OUTER 
         JOIN v$parameter p USING (NAME)
         JOIN v$session USING (SID)
   WHERE audsid = USERENV ('sessionid')
   ORDER BY isdefault, NAME;

