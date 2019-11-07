
create sequence s1 cache 10; 
declare
    x number;
begin
    for i in 1..1000000 loop
         select s1.nextval  into x from dual;  
    end loop;
end;
/
 
    
