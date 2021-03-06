rem *********************************************************** 
rem
rem	File: asm_files.sql 
rem	Description: ASM file level IO statistics 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 22 Page 647
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col rootname format a10 heading "Rootname|/DB Name " noprint
col diskgroup_name format a8 heading "Diskgroup|Name" noprint
col type format a10 heading "File|Type"
col filename format a23 heading "File|Name"
col allocated_mb format 999,999 heading "Allocated|MB"
col primary_region format a8 heading "Primary|Region"
col Striped format a6 heading "Stripe|Type"
col hot_ios1k format 99,999 heading "Hot IO|/1000"
col cold_ios1k format 99,999 heading "ColdIO|/1000"
set pagesize 10000 
set lines 80
set echo on 

SELECT  rootname,d.name diskgroup_name,f.TYPE, a.name filename,
       space / 1048576 allocated_mb, primary_region, striped,
       round((hot_reads + hot_writes)/1000,2) hot_ios1k, 
       round((cold_reads + cold_writes)/1000,2) cold_ios1k
  FROM (SELECT CONNECT_BY_ISLEAF, group_number, file_number, name,
               CONNECT_BY_ROOT name rootname, reference_index,
               parent_index
          FROM v$asm_alias a
       CONNECT BY PRIOR reference_index = parent_index) a
  JOIN (SELECT DISTINCT name
         FROM v$asm_alias
             /* top 8 bits of the parent_index is the group_number, so
                the following selects aliases whose parent is the group
                itself - eg top level directories within the disk group*/
        WHERE parent_index = group_number * POWER(2, 24)) b
           ON (a.rootname = b.name)
  JOIN v$asm_file f
       ON (a.group_number = f.group_number
         AND a.file_number = f.file_number)
  JOIN v$asm_diskgroup d
       ON (f.group_number = d.group_number)
 WHERE a.CONNECT_BY_ISLEAF = 1
 ORDER BY (cold_reads + cold_writes + hot_reads + hot_writes) DESC; 
