drop table bitmapped_index_table; 
create table bitmapped_index_table  ( x int , y varchar2(1000)); 
insert into bitmapped_index_table  values(1,1);
insert into bitmapped_index_table  values(2,1);
create bitmap index my_bitmapped_index1 on bitmapped_index_table (x) ; 
create bitmap index my_bitmapped_index2 on bitmapped_index_table (y) ; 

update bitmapped_index_table  set y=2 where x=1; 

