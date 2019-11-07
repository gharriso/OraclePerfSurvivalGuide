/* Formatted on 2008/10/07 08:12 (Formatter Plus v4.8.7) */
CREATE OR REPLACE DIRECTORY hprof_dir AS 'C:\Documents and Settings\gharriso\My Documents\Books\OPSG\Ch12 PLSQL';

DECLARE
   runid   NUMBER;
BEGIN
   hprof_demo_pkg.init(1000); 
   dbms_hprof.start_profiling('HPROF_DIR','hprof_trace.trc',max_depth=>10);
   hprof_demo_pkg.nightly_batch(); 
   dbms_hprof.stop_profiling ();
   runid :=
      dbms_hprof.ANALYZE (LOCATION         => 'HPROF_DIR',
                          filename         => 'hprof_trace.trc',
                          run_comment      => 'Hprof demo 1'
                         );
END;

