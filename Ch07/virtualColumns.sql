drop table products;
create table products as select * from sh.products; 
ALTER TABLE products ADD rounded_list_price GENERATED 
      ALWAYS AS (ROUND(prod_list_price,-2));
      
begin
    sys.dbms_stats.gather_table_stats(OWNNAME=>user, TABNAME=>'PRODUCTS');
end; 
/
set echo on 
explain plan for select * from products where rounded_list_price=1; 
select * from table(dbms_xplan.display());
explain plan for select * from products where ROUND(prod_list_price,-2)=1; 
select * from table(dbms_xplan.display());

create index virtual_i1 on products(rounded_list_price); 


    

