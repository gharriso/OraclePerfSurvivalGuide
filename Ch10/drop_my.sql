declare 
    v_sql varchar2(1000); 
begin
    for r in (select table_name from user_tables) loop
        v_sql:='drop table '||r.table_name||' cascade constraints '  ; 
        dbms_output.put_line(v_sql);
        execute immediate v_sql; 
    end loop;
end; 
/
