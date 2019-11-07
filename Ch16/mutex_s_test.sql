CREATE SEQUENCE cursor_s
   CACHE 1000000;

DECLARE
   l_elapsed   NUMBER:=0;
   l_start     NUMBER;
   l_num       NUMBER;
BEGIN
   l_start := DBMS_UTILITY.get_time();

   WHILE (l_elapsed < &1 ) LOOP
      SELECT cursor_s.nextval INTO l_num FROM DUAL;
      if (mod(l_num,1000)=0) then 
        l_elapsed:=(DBMS_UTILITY.get_time() - l_start) / 100;
      end if; 
   END LOOP;
END;
/

