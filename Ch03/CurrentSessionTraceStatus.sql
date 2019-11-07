rem *********************************************************** 
rem
rem	File: CurrentSessionTraceStatus.sql 
rem	Description: Show the full name and path of the trace file for the current session 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 3 Page 55
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


SELECT s.sql_trace, s.sql_trace_waits, s.sql_trace_binds,
          traceid, tracefile
     FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
    WHERE audsid = USERENV ('SESSIONID')
 
