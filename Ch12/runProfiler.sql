DECLARE
    l_run_id NUMBER;
BEGIN
    l_run_id:=sys.dbms_profiler.start_profiler(
        'Demo Run1');
    inline_demo.doitall;
    l_run_id:=sys.dbms_profiler.stop_profiler;
END;
commit; 