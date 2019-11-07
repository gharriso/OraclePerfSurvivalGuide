BEGIN
   sys.DBMS_ALERT.signal('GHR_STABLE', 'stable');
   COMMIT;
END;
/
 
