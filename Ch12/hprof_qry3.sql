col function format a33 heading "Function Call"
col calls format 99999 heading "Calls"
col function_elapsed_time heading "Function time"
col subtree_elapsed_time heading "Subtree time"
col subtree_only_time format 99999 heading "Subtree only"

set lines 100
set pages 1000

spool hprof_qry3
set echo on 

WITH dbmshp AS 
  (SELECT   module||'.'||function as function, 
            NVL(pci.calls,f.calls) calls,
            NVL(pci.function_elapsed_time,f.function_elapsed_Time)
               AS  function_elapsed_Time, 
            NVL(pci.subtree_elapsed_time,f.subtree_elapsed_time) 
               AS subtree_elapsed_time,
            f.symbolid , pci.parentsymid
     FROM   dbmshp_runs r
     JOIN   dbmshp_function_info f ON (r.runid = f.runid)
     FULL OUTER JOIN dbmshp_parent_child_info pci
            ON (pci.runid = r.runid AND pci.childsymid = f.symbolid)
    WHERE r.run_comment='Hprof demo 2')
 SELECT   rpad(' ',level)||function as function,calls, 
          function_elapsed_time,
          subtree_elapsed_time,
          subtree_elapsed_time-function_elapsed_Time 
             AS subtree_only_time 
   FROM   dbmshp
CONNECT BY   PRIOR symbolid = parentsymid
START WITH   parentsymid IS NULL; 

exit;
