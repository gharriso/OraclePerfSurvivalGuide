set timing on 
create table sales as select * from sh.sales; 

declare
   l_low_val   NUMBER;
   l_high_val number; 
   l_sql_text   VARCHAR2 (1000);
   l_cursor     PLS_INTEGER;
BEGIN
   FOR i IN 1 .. &1
   LOOP
      l_low_val := DBMS_RANDOM.value(7,1780);
      l_sql_text :=
         'select quantity_sold from dual where quantity_sold=''' || l_rand_num || '''';
      l_cursor := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (l_cursor, l_sql_text, DBMS_SQL.native);
      DBMS_SQL.close_cursor (l_cursor);
   END LOOP;
END;
/

select min(amount_sold) , max(amount_sold) from sales;  
