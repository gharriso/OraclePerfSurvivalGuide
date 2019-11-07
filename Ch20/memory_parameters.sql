set pagesize 1000
set lines 100
column name format a20
column description format a50
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
             
 


