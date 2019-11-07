DECLARE
   l_elapsed   NUMBER:=0;
   l_start     NUMBER;
   l_num       NUMBER;
BEGIN
   l_start := DBMS_UTILITY.get_time();

   WHILE (l_elapsed < &1 ) LOOP
      execute immediate 'grant select on log_data to system';
      begin 
      execute immediate 'revoke select on log_data from system';
      exception when others then null; end; 
      if (mod(l_num,1000)=0) then 
        l_elapsed:=(DBMS_UTILITY.get_time() - l_start) / 100;
      end if; 
   END LOOP;
END;
/
