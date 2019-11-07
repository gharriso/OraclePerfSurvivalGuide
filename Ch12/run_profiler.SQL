DECLARE
   ReturnCode   BINARY_INTEGER;
BEGIN
   ReturnCode   := DBMS_PROFILER.start_profiler ('Profiler Demo 1');
   opsg.opsg_dataload.addsales (source_year => 2002, target_year => 2009);
   ROLLBACK;
   ReturnCode   := DBMS_PROFILER.stop_profiler;
   DBMS_OUTPUT.put_line ('Profiler return code=' || ReturnCode);
   COMMIT;
END;
 
 
