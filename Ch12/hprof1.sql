/* Formatted on 2008/10/07 08:12 (Formatter Plus v4.8.7) */
CREATE OR REPLACE DIRECTORY hprof_dir AS '/tmp';

DECLARE
   runid   NUMBER;
BEGIN
   dbms_hprof.start_profiling('HPROF_DIR','demo1.trc',max_depth=>10);
   inline_demo.doitall ();
   dbms_hprof.stop_profiling ();
   runid :=
      dbms_hprof.ANALYZE (LOCATION         => 'HPROF_DIR',
                          filename         => 'demo1.trc',
                          run_comment      => 'Inline_demo.doitall() hprof'
                         );
END;

