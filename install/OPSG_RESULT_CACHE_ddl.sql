CREATE OR REPLACE PACKAGE opsg_result_cache is 
 
     FUNCTION rscache_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_sysstat_typ  ;

end; 
/
CREATE OR REPLACE PACKAGE BODY opsg_result_cache is 

  no_such_table EXCEPTION;
   PRAGMA EXCEPTION_INIT(no_such_table, -942);

   TYPE numlist IS
      TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;

   TYPE varlist IS
      TABLE OF VARCHAR2(1000)
         INDEX BY BINARY_INTEGER;

 
   TYPE rscache_val_typ IS
      TABLE OF NUMBER
         INDEX BY VARCHAR(1000);
  g_current_rscache      rscache_val_typ ;
   g_prev_rscache         rscache_val_typ ;

   g_prev_timestamp         DATE;
   g_current_timestamp      DATE;
   g_current_hsecs          NUMBER;
   g_prev_hsecs             NUMBER;

   g_rscache_data           opsg_sysstat_typ := opsg_sysstat_typ();

   FUNCTION db_start_time
      RETURN DATE IS
      v_start_time   DATE;
   BEGIN
      SELECT startup_time INTO v_start_time FROM v$instance;

      RETURN (v_start_time);
   END;
    PROCEDURE report_rscache_current IS
      v_stat_name       VARCHAR2(1000);
      v_start_time      DATE;
      v_interval_secs   NUMBER;
      v_stat_line       opsg_sysstat_line_typ;
      i                 NUMBER := 1;
   BEGIN
      g_rscache_data.DELETE();
      v_start_time := db_start_time;
      v_interval_secs := (g_current_timestamp - v_start_time) * 24 * 3600;
      v_stat_name := g_current_rscache.FIRST;

      WHILE v_stat_name IS NOT NULL LOOP
         g_rscache_data.EXTEND;
         v_stat_line :=
            opsg_sysstat_line_typ(v_start_time, g_current_timestamp,
            v_stat_name, g_current_rscache(v_stat_name),
            g_current_rscache(v_stat_name) / v_interval_secs);
         g_rscache_data(g_rscache_data.LAST) := v_stat_line;
         v_stat_name := g_current_rscache.NEXT(v_stat_name);
      END LOOP;
   END;
     PROCEDURE report_rscache_delta IS
      v_stat_name       VARCHAR2(1000);
      v_start_time      DATE;
      v_interval_secs   NUMBER;
      v_stat_line       opsg_sysstat_line_typ;
      v_delta           NUMBER; 
      i                 NUMBER := 1;
   BEGIN
      g_rscache_data.DELETE();
      v_start_time := g_prev_timestamp;  
      v_interval_secs := (g_current_timestamp - v_start_time) * 24 * 3600;
      v_stat_name := g_current_rscache.FIRST;

      WHILE v_stat_name IS NOT NULL LOOP
         g_rscache_data.EXTEND;
         v_delta:=(g_current_rscache(v_stat_name)-g_prev_rscache(v_stat_name));
         v_stat_line :=
            opsg_sysstat_line_typ(v_start_time, g_current_timestamp,
            v_stat_name,v_delta ,
            (v_delta/ v_interval_secs) );
           -- dbms_output.put_line(v_stat_name||' '||v_delta||' '||v_interval_secs);
         g_rscache_data(g_rscache_data.LAST) := v_stat_line;
         v_stat_name := g_current_rscache.NEXT(v_stat_name);
      END LOOP;
   END;
      PROCEDURE load_current_rscache IS
      v_names   DBMS_SQL.varchar2_table;
      v_vals    DBMS_SQL.number_table;
   BEGIN
      SELECT name, VALUE
      BULK COLLECT
      INTO v_names, v_vals
      FROM sys.v_$result_cache_statistics; 
      g_current_timestamp := SYSDATE;
      FOR i IN 1 .. v_names.COUNT() LOOP
         g_current_rscache(v_names(i)) := v_vals(i);
      END LOOP;
   END;
   
   PROCEDURE save_to_rscache_previous IS
   BEGIN
      g_prev_rscache := g_current_rscache;

      g_prev_hsecs  := g_current_hsecs ;
      g_prev_timestamp  := g_current_timestamp ;
   END;
   
  PROCEDURE reset_rscache_data IS
   BEGIN
      g_current_rscache.delete();
      g_prev_rscache.delete(); 
   END;
   FUNCTION rscache_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
      RETURN opsg_sysstat_typ IS
      v_return_data   opsg_sysstat_typ;
   BEGIN
      g_rscache_data := opsg_sysstat_typ();

      IF p_mode = 'RESET' THEN
         reset_rscache_data;
      END IF;

      load_current_rscache;

      IF g_prev_rscache.COUNT = 0 THEN
         report_rscache_current;
      ELSE
         report_rscache_delta;
      END IF;

      save_to_rscache_previous;
      RETURN (g_rscache_data);
   END;


end; 
/
