rem *********************************************************** 
rem
rem	File: hrpof_qry.sql 
rem	Description: Query agains the DBMSHP (hierarchical profiler) tables 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 12 Page 360
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


SELECT     RPAD (' ', LEVEL * 2 ) || fi.owner || '.' || fi.module ,
           fi.FUNCTION, pci.subtree_elapsed_time, pci.function_elapsed_time,
           pci.calls
      FROM dbmshp_parent_child_info pci JOIN dbmshp_function_info fi
           ON pci.runid = fi.runid AND pci.childsymid = fi.symbolid
     WHERE pci.runid = (SELECT MAX (runid)
                          FROM dbmshp_runs)
CONNECT BY PRIOR childsymid = parentsymid
START WITH pci.parentsymid = (SELECT MIN (parentsymid)
                                FROM dbmshp_parent_child_info);
