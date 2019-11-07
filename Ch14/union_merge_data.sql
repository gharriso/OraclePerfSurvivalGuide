drop database link ghec2a_proxy  ; 
CREATE DATABASE LINK ghec2a_proxy  CONNECT TO opsg IDENTIFIED BY opsg USING 'GHEC2A_PROXY';

drop database link g11r2 ; 
CREATE DATABASE LINK g11r2 CONNECT TO opsg IDENTIFIED BY opsg USING 'G11R2';

create or replace view merge_data as 
select 'slow disk' host ,append,stat_name,sum(micro_wait) wait_time_micro
      from wait_times@g11r2 group by append,stat_name
 union all 
  select  'fast disk' host ,append,stat_name,sum(micro_wait) from
      wait_times@ghec2a_proxy  group by append,stat_name  ; 
      
select * from merge_data;      
select host, append, 
 case when stat_name like 'log%' then 'Redo Log IO'
      when stat_name like 'db file%' then 'Conventional IO'
      when stat_name like 'direct%' then 'Direct IO'
      when stat_name like 'CPU' then 'CPU'
      else 'Other' end  category , stat_name, wait_time_micro 
 from merge_data order by wait_time_micro desc ;  

/* Formatted on 16/01/2009 2:13:23 PM (QP5 v5.120.811.25008) */
