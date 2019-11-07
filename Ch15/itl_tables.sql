drop table itl_lock_demo; 
create table itl_lock_demo 
( id number primary key,
  data char(20) not null)
 initrans 1 maxtrans 1 pctfree 0 ;
 
 insert into itl_lock_demo 
            (id, data)
   SELECT     ROWNUM  id,
              RPAD ('X',
                    10
                   )  data
         FROM DUAL
   CONNECT BY ROWNUM <= 1000;
   
commit;
select * from user_segments where segment_name='ITL_LOCK_DEMO' ;
select * from itl_lock_demo where id=1 for update; 

 
 
