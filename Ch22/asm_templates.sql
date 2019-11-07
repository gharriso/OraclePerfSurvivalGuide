rem *********************************************************** 
rem
rem	File: asm_templates.sql 
rem	Description: List all ASM templates 
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 22 Page 654
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


col template_name format a20 heading "Template|Name"
col system format a2 heading "System|Template?"
col redundancy format a8 heading "Redundancy"
col stripe format a8 heading "Stripe|type"
col primary_region format a6 heading "Primary|Regions"
set pagesize 1000
set lines 80
set echo on

SELECT t.name template_name, t.SYSTEM, t.redundancy, 
       t.stripe, t.primary_region
  FROM v$asm_template t
  JOIN v$asm_diskgroup d
    ON (d.group_number = t.group_number)
 WHERE d.name = 'DATA'
 ORDER BY t.name;
