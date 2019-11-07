declare 
    x number; 
begin 
    for i in 1..1000000 loop
      x:=mod(i,99);   
    end loop;  
end;
/
@@plsqltime
exit; 
