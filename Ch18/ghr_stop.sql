BEGIN
   sys.DBMS_ALERT.signal('GHR_STOP', 'stop');
   COMMIT;
END;
/
 
