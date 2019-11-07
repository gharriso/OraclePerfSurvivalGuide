set echo on
ALTER SESSION SET workarea_size_policy = manual;
ALTER SESSION SET sort_area_size = 838860800;
ALTER SESSION SET sort_area_size = 838860800;
/* Formatted on 5/03/2009 11:17:21 AM (QP5 v5.120.811.25008) */
col event format a20

set serveroutput on 
exec big_sort(&1)

alter session set workarea_size_policy = auto;

select * from my_wait_view; 
exit; 
