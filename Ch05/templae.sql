 
ALTER SESSION SET tracefile_identifier=iot1;

SET pages 1000
SET lines 160
SET echo on
set timing on 

SPOOL iot1
rem 
rem object creation here
rem


BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/

BEGIN
   DBMS_STATS.gather_schema_stats (ownname => USER);
END;
/

SET autotrace on
rem
rem Queries, etc, here 
rem


set autotrace off 
SELECT  tracefile
      FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
      WHERE audsid = USERENV ('SESSIONID'); 
      
exit; 




