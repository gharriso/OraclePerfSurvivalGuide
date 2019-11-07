declare
    v_sql varchar2(1000); 
begin 
    for r in (select * from v$session where module='FLASHBACK_DED') loop
        v_sql:='alter system disconnect session '''||r.sid||','||r.session#||''' post transaction immediate '; 
        dbms_output.put_line(v_sql);
        execute immediate v_sql; 
    end loop;
end; 
