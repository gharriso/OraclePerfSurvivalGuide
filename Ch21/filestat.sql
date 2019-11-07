rem *********************************************************** 
rem
rem	File: filestat.sql 
rem	Description: Summary report from v$filestat
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 21 Page 622
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col tablespace_name format a20 heading "Tablespace Name"
col phyrds_1000 format 999,999 heading "Reads|\1000"
col avg_blk_reads format 99.99 heading "Avg Blks|per rd" noprint
col iotime_hrs format 9,999,999 heading "IO Time|(hrs)"
col pct_io format 99.99 heading "Pct|IO Time"
col phywrts_1000 format 999,999 heading "Writes|\1000"
col writetime_sec format 99,999,999 heading "Write Time|(s)"
col singleblkrds_1000 format  999,999 heading "Single blk|Reads\1000"
col single_rd_avg_time format 999.99 heading "Single Blk|Rd Avg (ms)"
set echo on

with filestat as 
    (SELECT tablespace_name, phyrds, phywrts, phyblkrd, phyblkwrt, 
            singleblkrds, readtim, writetim, singleblkrdtim
       FROM v$tempstat JOIN dba_temp_files
         ON (file# = file_id)
      UNION
     SELECT tablespace_name, phyrds, phywrts, phyblkrd, phyblkwrt, 
            singleblkrds, readtim, writetim, singleblkrdtim
       FROM v$filestat  JOIN dba_data_files
         ON (file# = file_id)) 
SELECT tablespace_name, ROUND(SUM(phyrds) / 1000) phyrds_1000,
       ROUND(SUM(phyblkrd) / SUM(phyrds), 2) avg_blk_reads,
       ROUND((SUM(readtim) + SUM(writetim)) / 100 / 3600, 2) iotime_hrs,
       ROUND(SUM(phyrds + phywrts) * 100 / SUM(SUM(phyrds + phywrts)) 
            OVER (), 2) pct_io, ROUND(SUM(phywrts) / 1000) phywrts_1000,
       ROUND(SUM(singleblkrdtim) * 10 / SUM(singleblkrds), 2)
          single_rd_avg_time
 FROM filestat 
GROUP BY tablespace_name
ORDER BY (SUM(readtim) + SUM(writetim)) DESC;
 
