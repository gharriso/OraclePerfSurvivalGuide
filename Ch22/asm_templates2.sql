col template_name format a20 heading "Template|Name"
col system format a2 heading "System|Template?"
col redundancy format a8 heading "Redundancy"
col stripe format a8 heading "Stripe|type"
col primary_region format a6 heading "Primary|Regions"
set pagesize 1000
set lines 80 
set echo on 

SELECT  t.name template_name, t.SYSTEM, t.redundancy,
       t.stripe, t.primary_region
FROM     v$asm_template t
     JOIN
         v$asm_diskgroup d
     ON (d.group_number = t.group_number)
where d.name='DATA'
order by t.name ; 
