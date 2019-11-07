CREATE OR REPLACE PACKAGE opsg_pkg IS
    FUNCTION wait_time_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_time_model_typ;

    FUNCTION sysstat_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_sysstat_typ;

    FUNCTION rac_wait_time_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_time_model_typ;
    FUNCTION service_stat_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_servstat_typ;
END;
/
CREATE OR REPLACE PACKAGE BODY opsg_pkg IS
    no_such_table exception;
    PRAGMA EXCEPTION_INIT(no_such_table, -942);

    TYPE numlist IS TABLE OF NUMBER
                        INDEX BY BINARY_INTEGER;

    TYPE varlist IS TABLE OF VARCHAR2(1000)
                        INDEX BY BINARY_INTEGER;

    TYPE event_stat_typ IS TABLE OF NUMBER
                               INDEX BY VARCHAR(1000);

    TYPE sysstat_val_typ IS TABLE OF NUMBER
                                INDEX BY VARCHAR(1000);

    TYPE csr_typ IS REF CURSOR;


    g_firstnames                   varlist;
    g_surnames                     varlist;
    g_current_sysstats             sysstat_val_typ;
    g_prev_sysstats                sysstat_val_typ;


    g_prev_hsecs_ss                NUMBER;
    g_current_hsecs_ss             NUMBER;
    g_prev_timestamp_ss            DATE;
    g_current_timestamp_ss         DATE;
    g_current_waits                event_stat_typ;
    g_current_microseconds         event_stat_typ;
    g_prev_waits                   event_stat_typ;
    g_prev_microseconds            event_stat_typ;
    g_prev_timestamp               DATE;
    g_current_timestamp            DATE;
    g_current_hsecs                NUMBER;
    g_prev_hsecs                   NUMBER;
    g_time_model_data              opsg_time_model_typ := opsg_time_model_typ();
    g_sysstat_data                 opsg_sysstat_typ := opsg_sysstat_typ();
    g_rac_mode                     BOOLEAN := FALSE;

    g_servstat_data                opsg_servstat_typ := opsg_servstat_typ();
    g_current_servstat             opsg_servstat_typ := opsg_servstat_typ();
    g_prev_servstat                opsg_servstat_typ := opsg_servstat_typ();
    g_prev_servstat_timestamp      DATE;
    g_current_servstat_timestamp   DATE;

    --
    -- Return the text of the main time model query
    -- We return this as a string, so that we can dynamically
    -- execute and check for permissions problems at run time
    --
    FUNCTION time_model_qry
        RETURN VARCHAR2 IS
        v_return_string   VARCHAR2(2000);
    BEGIN
        v_return_string :=
            '
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
        RETURN (v_return_string);
    END;

    FUNCTION db_start_time
        RETURN DATE IS
        v_start_time   DATE;
    BEGIN
        SELECT startup_time INTO v_start_time FROM v$instance;

        RETURN (v_start_time);
    END;

    PROCEDURE save_to_previous IS
    BEGIN
        g_prev_waits := g_current_waits;
        g_prev_microseconds := g_current_microseconds;
        g_prev_hsecs := g_current_hsecs;
        g_prev_timestamp := g_current_timestamp;
    END;

    PROCEDURE save_to_sysstat_previous IS
    BEGIN
        g_prev_sysstats := g_current_sysstats;

        g_prev_hsecs_ss := g_current_hsecs_ss;
        g_prev_timestamp_ss := g_current_timestamp_ss;
    END;

    PROCEDURE load_current_waits IS
        csr_var          csr_typ;
        v_event          varlist;
        v_microseconds   numlist;
        v_total_waits    numlist;
        v_avg_wait       numlist;
        v_pct            numlist;
    BEGIN
        OPEN csr_var FOR time_model_qry();

        FETCH csr_var
        BULK COLLECT INTO v_event, v_microseconds, v_total_waits,
                          v_avg_wait, v_pct;

        CLOSE csr_var;

        SELECT hsecs INTO g_current_hsecs FROM sys.v_$timer;

        g_current_timestamp := SYSDATE;

        FOR i IN 1 .. v_event.COUNT LOOP
            g_current_waits(v_event(i)) := v_total_waits(i);
            g_current_microseconds(v_event(i)) := v_microseconds(i);
        END LOOP;
    END;

    PROCEDURE report_current IS
        v_stat_name       VARCHAR2(1000);
        v_start_time      DATE;
        v_interval_secs   NUMBER;
        v_stat_line       opsg_time_model_line_typ;
        i                 NUMBER := 1;
    BEGIN
        g_time_model_data.delete();
        v_start_time := db_start_time;
        v_interval_secs := (g_current_timestamp - v_start_time) * 24 * 3600;
        v_stat_name := g_current_waits.FIRST;

        WHILE v_stat_name IS NOT NULL LOOP
            g_time_model_data.EXTEND;
            v_stat_line :=
                opsg_time_model_line_typ(v_start_time, g_current_timestamp,
                v_stat_name, g_current_waits(v_stat_name),
                g_current_microseconds(v_stat_name),
                g_current_waits(v_stat_name) / v_interval_secs,
                g_current_microseconds(v_stat_name) / v_interval_secs);
            g_time_model_data(g_time_model_data.LAST) := v_stat_line;
            v_stat_name := g_current_waits.NEXT(v_stat_name);
        END LOOP;
    END;

    PROCEDURE report_delta IS
        v_stat_name       VARCHAR2(1000);
        v_start_time      DATE;
        v_interval_secs   NUMBER;
        v_stat_line       opsg_time_model_line_typ;
        i                 NUMBER := 1;
    BEGIN
        g_time_model_data.delete();
        v_start_time := g_prev_timestamp;
        v_interval_secs := (g_current_timestamp - v_start_time) * 24 * 3600;
        v_stat_name := g_current_waits.FIRST;

        WHILE v_stat_name IS NOT NULL LOOP
            --DBMS_OUTPUT.put_line(v_stat_name);
            g_time_model_data.EXTEND;
            v_stat_line :=
                opsg_time_model_line_typ(v_start_time, g_current_timestamp,
                v_stat_name,
                g_current_waits(v_stat_name) - g_prev_waits(v_stat_name),
                g_current_microseconds(v_stat_name) - g_prev_microseconds(v_stat_name),
                (g_current_waits(v_stat_name) - g_prev_waits(v_stat_name)) / v_interval_secs,
                (g_current_microseconds(v_stat_name)
                 - g_prev_microseconds(v_stat_name))
                / v_interval_secs);
            g_time_model_data(g_time_model_data.LAST) := v_stat_line;
            v_stat_name := g_current_waits.NEXT(v_stat_name);
        END LOOP;
    END;

    PROCEDURE reset_data IS
    BEGIN
        g_current_waits.delete;
        g_current_microseconds.delete;
        g_prev_waits.delete;
        g_prev_microseconds.delete;
        g_prev_timestamp := NULL;
        g_current_timestamp := NULL;
    END;

    --
    -- Function to return time model and event data statistics
    -- Usage:
    --  select * from table(opsg_pkg.opsg_time_model());
    --
    -- First call in a session will return statistics since the
    -- database start.  Subsequent calls will return delta statistics
    -- since last called.
    --
    --
    FUNCTION wait_time_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_time_model_typ IS
        v_return_data   opsg_time_model_typ;
    BEGIN
        g_time_model_data := opsg_time_model_typ();

        IF p_mode = 'RESET' THEN
            reset_data;
        END IF;

        load_current_waits;

        IF g_prev_waits.COUNT = 0 THEN
            report_current;
        ELSE
            report_delta;
        END IF;

        save_to_previous;
        RETURN (g_time_model_data);
    END;


    PROCEDURE report_sysstat_current IS
        v_stat_name       VARCHAR2(1000);
        v_start_time      DATE;
        v_interval_secs   NUMBER;
        v_stat_line       opsg_sysstat_line_typ;
        i                 NUMBER := 1;
    BEGIN
        g_sysstat_data.delete();
        v_start_time := db_start_time;
        v_interval_secs :=
            (g_current_timestamp_ss - v_start_time) * 24 * 3600;
        v_stat_name := g_current_sysstats.FIRST;

        WHILE v_stat_name IS NOT NULL LOOP
            g_sysstat_data.EXTEND;
            v_stat_line :=
                opsg_sysstat_line_typ(v_start_time, g_current_timestamp_ss,
                v_stat_name, g_current_sysstats(v_stat_name),
                g_current_sysstats(v_stat_name) / v_interval_secs);
            g_sysstat_data(g_sysstat_data.LAST) := v_stat_line;
            v_stat_name := g_current_sysstats.NEXT(v_stat_name);
        END LOOP;
    END;

    PROCEDURE report_sysstat_delta IS
        v_stat_name       VARCHAR2(1000);
        v_start_time      DATE;
        v_interval_secs   NUMBER;
        v_stat_line       opsg_sysstat_line_typ;
        v_delta           NUMBER;
        i                 NUMBER := 1;
    BEGIN
        g_sysstat_data.delete();
        v_start_time := g_prev_timestamp_ss;
        v_interval_secs :=
            (g_current_timestamp_ss - v_start_time) * 24 * 3600;
        v_stat_name := g_current_sysstats.FIRST;

        WHILE v_stat_name IS NOT NULL LOOP
            g_sysstat_data.EXTEND;
            v_delta :=
                (g_current_sysstats(v_stat_name)
                 - g_prev_sysstats(v_stat_name));
            v_stat_line :=
                opsg_sysstat_line_typ(v_start_time, g_current_timestamp_ss,
                v_stat_name, v_delta, (v_delta / v_interval_secs));
            -- dbms_output.put_line(v_stat_name||' '||v_delta||' '||v_interval_secs);
            g_sysstat_data(g_sysstat_data.LAST) := v_stat_line;
            v_stat_name := g_current_sysstats.NEXT(v_stat_name);
        END LOOP;
    END;

    PROCEDURE reset_sysstat_data IS
    BEGIN
        g_current_sysstats.delete();
        g_prev_sysstats.delete();
    END;

    -- Get current values from V$sysstat
    PROCEDURE load_current_sysstat IS
        v_names   DBMS_SQL.varchar2_table;
        v_vals    DBMS_SQL.number_table;
    BEGIN
        SELECT name, VALUE
        BULK COLLECT
        INTO v_names, v_vals
        FROM sys.v_$sysstat;

        g_current_timestamp_ss := SYSDATE;

        FOR i IN 1 .. v_names.COUNT() LOOP
            g_current_sysstats(v_names(i)) := v_vals(i);
        END LOOP;
    END;

    FUNCTION sysstat_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_sysstat_typ IS
        v_return_data   opsg_sysstat_typ;
    BEGIN
        g_sysstat_data := opsg_sysstat_typ();

        IF p_mode = 'RESET' THEN
            reset_sysstat_data;
        END IF;

        load_current_sysstat;

        IF g_prev_sysstats.COUNT = 0 THEN
            report_sysstat_current;
        ELSE
            report_sysstat_delta;
        END IF;

        save_to_sysstat_previous;
        RETURN (g_sysstat_data);
    END;

    FUNCTION opsg_time_model_o(p_wait_time IN INTEGER DEFAULT 15 /*Time (in seconds) to calculate rates over */
                                                                )
        RETURN opsg_time_model_typ IS
        TYPE csr_typ IS REF CURSOR;

        v_time_model_qry       VARCHAR2(2000);
        v_start_waits          event_stat_typ;
        v_start_microseconds   event_stat_typ;
        v_single_line          opsg_time_model_line_typ;
        v_return_tab opsg_time_model_typ
                := opsg_time_model_typ();
        csr_var                csr_typ;
        v_event                varlist;
        v_microseconds         numlist;
        v_total_waits          numlist;
        v_avg_wait             numlist;
        v_pct                  numlist;
        v_starttime            NUMBER;
        v_endtime              NUMBER;
        v_elapsed_seconds      NUMBER;
    BEGIN
        v_time_model_qry := time_model_qry();

        OPEN csr_var FOR v_time_model_qry;

        FETCH csr_var
        BULK COLLECT INTO v_event, v_microseconds, v_total_waits,
                          v_avg_wait, v_pct;

        CLOSE csr_var;

        FOR i IN 1 .. v_event.COUNT LOOP
            v_start_waits(v_event(i)) := v_total_waits(i);
            v_start_microseconds(v_event(i)) := v_microseconds(i);
        END LOOP;

        SELECT hsecs INTO v_starttime FROM sys.v_$timer;

        sys.DBMS_LOCK.sleep(p_wait_time);

        OPEN csr_var FOR v_time_model_qry;

        FETCH csr_var
        BULK COLLECT INTO v_event, v_microseconds, v_total_waits,
                          v_avg_wait, v_pct;

        CLOSE csr_var;

        SELECT hsecs INTO v_endtime FROM sys.v_$timer;

        v_elapsed_seconds := (v_endtime - v_starttime) / 100;

        FOR i IN 1 .. v_event.COUNT LOOP
            v_single_line :=
                opsg_time_model_line_typ(NULL, NULL, v_event(i),
                v_total_waits(i), v_microseconds(i),
                (v_total_waits(i) - v_start_waits(v_event(i))) / v_elapsed_seconds,
                (v_microseconds(i) - v_start_microseconds(v_event(i)))
                / v_elapsed_seconds);
            v_return_tab.EXTEND;
            v_return_tab(v_return_tab.LAST) := v_single_line;
        END LOOP;

        RETURN (v_return_tab);
    EXCEPTION
        WHEN no_such_table THEN
            raise_application_error(-20001,
            'This script needs SELECT ANY DICTIONARY privilege');
    END;

    FUNCTION rac_wait_time_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_time_model_typ IS
    BEGIN
        g_rac_mode := TRUE;
        RETURN (wait_time_report(p_mode));
    END;


    PROCEDURE servstat_reset_data IS
    BEGIN
        g_servstat_data.delete();
        g_prev_servstat.delete();
    END;

    PROCEDURE load_current_servstat IS
        CURSOR servstat_csr IS
            SELECT startup_time, inst_id, service_name, stat_name, VALUE
            FROM     gv$service_stats
                 JOIN
                     gv$instance
                 USING (inst_id)
            WHERE stat_name IN ('DB CPU', 'DB time');
        v_stat_line   opsg_servstat_line_typ;
    BEGIN
        g_current_servstat.delete;

        FOR r IN servstat_csr LOOP
            v_stat_line :=
                opsg_servstat_line_typ(r.startup_time, SYSDATE, r.inst_id,
                r.service_name, r.stat_name, r.VALUE);

            g_current_servstat.EXTEND();
            g_current_servstat(g_current_servstat.LAST) := v_stat_line;
        END LOOP;

        g_servstat_data := g_current_servstat;
        g_current_servstat_timestamp := SYSDATE;
    END;

    PROCEDURE report_current_servstat IS
    BEGIN
        g_servstat_data := g_current_servstat;
    END;

    PROCEDURE save_to_previous_servstat IS
    BEGIN
        g_prev_servstat := g_current_servstat;
        g_prev_servstat_timestamp := g_current_servstat_timestamp;
    END;

    PROCEDURE report_delta_servstat IS
        v_current      opsg_servstat_line_typ;
        v_prev_found   BOOLEAN;
        v_prev         opsg_servstat_line_typ;
        v_start_time   DATE;
        v_delta        opsg_servstat_line_typ;
        delta_value    NUMBER;
    BEGIN
        v_start_time := g_prev_servstat_timestamp;

        g_servstat_data.delete;

        FOR i IN 1 .. g_current_servstat.COUNT LOOP
            v_current := g_current_servstat(i);
            v_prev_found := FALSE;

            FOR j IN 1 .. g_prev_servstat.COUNT LOOP
                IF g_prev_servstat(j).inst_id = v_current.inst_id
                   AND g_prev_servstat(j).service_name =
                          v_current.service_name
                   AND g_prev_servstat(j).stat_name = v_current.stat_name THEN
                    v_prev := g_prev_servstat(j);
                    v_prev_found := TRUE;
                    EXIT;
                END IF;
            END LOOP;

            IF v_prev_found THEN
                delta_value := v_current.VALUE - v_prev.VALUE;
            ELSE
                delta_value := v_current.VALUE;
            END IF;
            v_delta :=
                opsg_servstat_line_typ(g_prev_servstat_timestamp,
                g_current_servstat_timestamp, v_current.inst_id,
                v_current.service_name, v_current.stat_name, delta_value);
            g_servstat_data.EXTEND;
            g_servstat_data(g_servstat_data.LAST) := v_delta;
        END LOOP;
    END;

    FUNCTION service_stat_report(p_mode VARCHAR2 DEFAULT 'NORMAL')
        RETURN opsg_servstat_typ IS
        v_diag_string   VARCHAR2(200) := ' ';
    BEGIN
        g_servstat_data := opsg_servstat_typ();

        IF p_mode = 'RESET' THEN
            servstat_reset_data;
            v_diag_string := v_diag_string || 'RESET';
        END IF;

        load_current_servstat;

        IF g_prev_servstat.COUNT = 0 THEN
            report_current_servstat;
            v_diag_string := v_diag_string || ' CURRENT';
        ELSE
            report_delta_servstat;
            v_diag_string := v_diag_string || ' DELTA';
        END IF;

        save_to_previous_servstat;
        IF g_servstat_data.COUNT = 0 THEN
            raise_application_error(-20002, 'No data: ' || v_diag_string);
        END IF;
        RETURN (g_servstat_data);
    END;

    PROCEDURE testit IS
    BEGIN
        NULL;
    END;
END;
/
