DECLARE
   v_sql   VARCHAR2(1000);
BEGIN
   FOR r IN (SELECT sid, serial#
             FROM v$session
             WHERE username = 'OPSG' AND program LIKE 'sqlplus%') LOOP
      BEGIN
         v_sql :=
            'alter system kill session ''' || r.sid || ',' || r.serial# || ''' immediate ';
         DBMS_OUTPUT.put_line(v_sql);

         EXECUTE IMMEDIATE v_sql;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line(SQLERRM);
      END;
   END LOOP;
END;
/

/* Formatted on 12-Mar-2009 15:09:53 (QP5 v5.120.811.25008) */
