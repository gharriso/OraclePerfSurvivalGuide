CREATE OR REPLACE FUNCTION OPSG_TIME_MODEL (
   p_wait_time   IN   INTEGER
         DEFAULT 15             /*Time (in seconds) to calculate rates over */
)
   RETURN opsg_time_model_typ
IS
   no_such_table      EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_such_table, -942);

   TYPE csr_typ IS REF CURSOR;

   TYPE numlist IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE varlist IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   TYPE event_stat_typ IS TABLE OF NUMBER
      INDEX BY VARCHAR (1000);

   v_time_model_qry   VARCHAR2 (2000)
      DEFAULT '
   WITH time_model AS
     (
        SELECT /*+ materialize */
               SUM
                  (CASE
                      WHEN stat_name IN (''DB time'', ''background cpu time'')
                         THEN VALUE
                   END
                  ) AS cpu_time,
               SUM
                  (CASE
                      WHEN stat_name IN
                                       (''background elapsed time'', ''DB time'')
                         THEN VALUE
                   END
                  ) AS active_time
          FROM sys.v_$sys_time_model
         WHERE stat_name IN
                  (''DB time'',
                   ''DB CPU'',
                   ''background elapsed time'',
                   ''background cpu time''
                  )),
     wait_interface AS
     (
        SELECT   /*+ materialize */
                 event,
                  time_waited_micro  microseconds,
                    total_waits  total_waits
            FROM   sys.v_$system_event e                 
           WHERE e.wait_class <> ''Idle''
        )
   SELECT   event, microseconds, total_waits,
         ROUND (microseconds / total_waits) avg_wait,
         ROUND (microseconds * 100 / SUM (microseconds) OVER (), 2) pct
    FROM (SELECT event, microseconds, total_waits
            FROM wait_interface
          UNION
          SELECT ''CPU'', cpu_time, NULL
            FROM time_model
          UNION
          SELECT ''Other'',
                 GREATEST (active_time - cpu_time - wait_time, 0) other_time,
                 NULL
            FROM time_model
                 CROSS JOIN
                 (SELECT SUM (microseconds) wait_time
                    FROM wait_interface) w
                 )
     ORDER BY 2 DESC';
   v_start_waits      event_stat_typ;
   v_start_microseconds       event_stat_typ;
   v_single_line      opsg_time_model_line_typ;
   v_return_tab       opsg_time_model_typ      := opsg_time_model_typ ();
   csr_var            csr_typ;
   v_event            varlist;
   v_microseconds     numlist;
   v_total_waits      numlist;
   v_avg_wait         numlist;
   v_pct              numlist;
   v_starttime  number;
   v_endtime number; 
   v_elapsed_seconds number; 
BEGIN
   OPEN csr_var FOR v_time_model_qry;

   FETCH csr_var
   BULK COLLECT INTO v_event, v_microseconds, v_total_waits, v_avg_wait,
          v_pct;

   CLOSE csr_var;

   FOR i IN 1 .. v_event.COUNT
   LOOP
      v_start_waits (v_event (i)) := v_total_waits (i);
      v_start_microseconds (v_event (i)) := v_microseconds (i);
   END LOOP;
   
   select hsecs into v_starttime from sys.v_$timer; 

   sys.dbms_lock.sleep(p_wait_time); 
   OPEN csr_var FOR v_time_model_qry;

   FETCH csr_var
   BULK COLLECT INTO v_event, v_microseconds, v_total_waits, v_avg_wait,
          v_pct;

   CLOSE csr_var;
      select hsecs into v_endtime from sys.v_$timer;
   v_elapsed_seconds:=(v_endtime-v_starttime)/100     ; 
   FOR i IN 1 .. v_event.COUNT
   LOOP
      v_single_line :=
         opsg_time_model_line_typ (v_event (i),
                                   v_total_waits (i),
                                   v_microseconds (i),
                                   (v_total_waits (i)-v_start_waits(v_event (i)))/
                                   v_elapsed_seconds,
                                   
                                   (v_microseconds (i)-v_start_microseconds(v_event (i)))/
                                   v_elapsed_seconds
                                  );
      v_return_tab.EXTEND;
      v_return_tab (v_return_tab.LAST) := v_single_line;
   END LOOP;

   RETURN (v_return_tab);
EXCEPTION
   WHEN no_such_table
   THEN
      raise_application_error
                         (-20001,
                          'This script needs SELECT ANY DICTIONARY privilege'
                         );
END;
