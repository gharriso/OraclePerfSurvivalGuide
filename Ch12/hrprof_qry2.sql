SELECT level, rpad(' ',level)||function, SYMBOLID,PARENTSYMID,CHILDSYMID,MODULE,FUNCTION
  FROM       dbmshp_function_info fi
          JOIN
             dbmshp_runs r
          ON (r.runid = fi.runid)
       LEFT OUTER JOIN
          dbmshp_parent_child_info pci
       ON (fi.runid = pci.runid AND pci.childsymid = fi.SYMBOLID)
    CONNECT BY PRIOR symbolid=parentsymid
    start with parentsymid is null  
 
/* Formatted on 3/12/2008 6:14:47 PM (QP5 v5.120.811.25008) */
