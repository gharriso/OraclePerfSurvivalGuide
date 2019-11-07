CREATE OR REPLACE PACKAGE BODY opsg_dataload IS
    TYPE first_name_typ IS TABLE OF hr.employees.first_name%TYPE
                               INDEX BY BINARY_INTEGER;

    TYPE surname_typ IS TABLE OF hr.employees.last_name%TYPE
                            INDEX BY BINARY_INTEGER;

    TYPE employees_typ IS TABLE OF hr.employees%ROWTYPE
                              INDEX BY BINARY_INTEGER;

    TYPE job_history_typ IS TABLE OF hr.job_history%ROWTYPE
                                INDEX BY BINARY_INTEGER;

    TYPE jobs_typ IS TABLE OF hr.jobs%ROWTYPE
                         INDEX BY BINARY_INTEGER;

    g_first_names   first_name_typ;
    g_surnames      surname_typ;
    g_max_job_no    NUMBER;
    g_employees     employees_typ;
    g_job_history   job_history_typ;
    g_jobs          jobs_typ;

    -- Load collections with names to generate random people
    PROCEDURE populatenames IS
    BEGIN
        -- THe rank() stuff here ensures we only get the employees originally
        -- loaded by oracle
        SELECT DISTINCT first_name
        BULK COLLECT
        INTO g_first_names
        FROM hr.employees
        UNION
        SELECT cust_first_name FROM oe.customers;

        SELECT DISTINCT last_name
        BULK COLLECT
        INTO g_surnames
        FROM hr.employees
        UNION
        SELECT cust_last_name FROM oe.customers;

        SELECT *
        BULK COLLECT
        INTO g_employees
        FROM hr.employees
        WHERE phone_number LIKE '%.%'; --we don't use 'dots' in our employees
    END;

    FUNCTION nextempid
        RETURN NUMBER IS
        v_new_employee_id   NUMBER;
    BEGIN
        SELECT hr.employees_seq.NEXTVAL INTO v_new_employee_id FROM DUAL;

        RETURN (v_new_employee_id);
    END;

    FUNCTION randomfirstname
        RETURN VARCHAR2 IS
    BEGIN
        RETURN (g_first_names(DBMS_RANDOM.VALUE(1, g_first_names.COUNT)));
    END;

    FUNCTION randomsurname
        RETURN VARCHAR2 IS
    BEGIN
        RETURN (g_surnames(DBMS_RANDOM.VALUE(1, g_surnames.COUNT)));
    END;

    PROCEDURE clone_job_history(v_orig_employee_id    NUMBER,
                                p_new_employee_id     NUMBER) IS
        v_offset   NUMBER;
    BEGIN
        v_offset := DBMS_RANDOM.VALUE(-100, 100);

        INSERT INTO hr.job_history(employee_id, start_date, end_date, job_id, department_id)
            SELECT p_new_employee_id, start_date + v_offset,
                   end_date + v_offset, job_id, department_id
            FROM hr.job_history
            WHERE employee_id = v_orig_employee_id;
    END;

    PROCEDURE clone_employee(p_new_employee_id    NUMBER,
                             p_employee_row       hr.employees%ROWTYPE) IS
        v_employee_row       hr.employees%ROWTYPE;
        v_orig_employee_id   NUMBER;
    BEGIN
        v_orig_employee_id := p_employee_row.employee_id;
        v_employee_row := p_employee_row;
        v_employee_row.employee_id := p_new_employee_id;
        v_employee_row.first_name := randomfirstname();
        v_employee_row.last_name := randomsurname();
        v_employee_row.phone_number :=
            TRANSLATE(v_employee_row.phone_number, '.', '-');
        v_employee_row.email :=
               SUBSTR(v_employee_row.first_name, 1, 8)
            || p_new_employee_id
            || '@abc.com';
        v_employee_row.hire_date := SYSDATE - DBMS_RANDOM.VALUE(30, 1000);

        INSERT INTO hr.employees
        VALUES v_employee_row;

        clone_job_history(v_orig_employee_id, p_new_employee_id);
    END;

    FUNCTION addbatch(p_limit NUMBER)
        RETURN NUMBER IS
        v_employee_row      hr.employees%ROWTYPE;
        v_new_employee_id   NUMBER;
    BEGIN
        FOR i IN 1 .. LEAST(g_employees.COUNT, p_limit) LOOP
            v_employee_row := g_employees(i);
            v_new_employee_id := nextempid();
            clone_employee(v_new_employee_id, v_employee_row);
        END LOOP;

        RETURN (g_employees.COUNT);
    END;

    PROCEDURE addemployees(employee_count NUMBER) IS
        l_count   NUMBER := 0;
    BEGIN
        -- Load up names if not already loaded
        IF (g_first_names.COUNT = 0) THEN
            populatenames();
        END IF;

        WHILE (l_count < employee_count) LOOP
            l_count := l_count + addbatch(employee_count);
        END LOOP;
    END;

    FUNCTION createtime(p_time_id      DATE,
                        source_date    DATE)
        RETURN sh.times%ROWTYPE IS
        new_row       sh.times%ROWTYPE;
        days_offset   NUMBER;
        thisyear      NUMBER;
    BEGIN
        /* NB:  Don't really get the fiscal year stuff, so that might be wrong.
           Also columns like quarter_id have not beeen coverted */
        BEGIN
            SELECT *
            INTO new_row
            FROM sh.times
            WHERE time_id = source_date;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                raise_application_error(-20101,
                'No data for ' || source_date || ' in sh.times');
        END;

        days_offset := p_time_id - new_row.time_id;
        thisyear := TO_CHAR(p_time_id, 'YYYY');
        new_row.time_id := p_time_id;
        new_row.day_name := TO_CHAR(p_time_id, 'DAY');
        new_row.day_number_in_week := TO_CHAR(p_time_id, 'D');
        new_row.day_number_in_month := TO_CHAR(p_time_id, 'DD');
        new_row.calendar_week_number := TO_CHAR(p_time_id, 'IW');
        new_row.fiscal_week_number := TO_CHAR(p_time_id, 'IW');
        new_row.week_ending_day :=
            p_time_id + 7 - new_row.day_number_in_week;
        new_row.week_ending_day_id :=
            new_row.week_ending_day_id + days_offset;
        new_row.calendar_month_number := TO_CHAR(p_time_id, 'MM');
        new_row.fiscal_month_number := TO_CHAR(p_time_id, 'MM');
        new_row.calendar_month_desc := TO_CHAR(p_time_id, 'YYYY-MM');
        new_row.calendar_month_id :=
            new_row.calendar_month_id + days_offset;
        new_row.fiscal_month_desc := TO_CHAR(p_time_id, 'YYYY-MM');
        new_row.fiscal_month_id := new_row.fiscal_month_id + days_offset;
        new_row.end_of_cal_month := LAST_DAY(p_time_id);
        new_row.end_of_fis_month := LAST_DAY(p_time_id);
        new_row.calendar_month_name := TO_CHAR(p_time_id, 'MONTH');
        new_row.fiscal_month_name := TO_CHAR(p_time_id, 'MONTH');
        new_row.calendar_quarter_desc := TO_CHAR(p_time_id, 'YYYY-Q');
        new_row.fiscal_quarter_desc := TO_CHAR(p_time_id, 'YYYY-Q');
        new_row.end_of_cal_quarter :=
            TO_DATE(TO_CHAR(new_row.end_of_cal_quarter, 'DD-MON-')
                    || thisyear, 'DD-MON-YYYY');
        new_row.end_of_fis_quarter := new_row.end_of_cal_quarter;
        new_row.calendar_quarter_number := TO_CHAR(p_time_id, 'Q');
        new_row.fiscal_quarter_number := TO_CHAR(p_time_id, 'Q');
        new_row.calendar_year := TO_CHAR(p_time_id, 'YYYY');
        new_row.fiscal_year := TO_CHAR(p_time_id, 'YYYY');
        new_row.days_in_cal_year :=
            TO_DATE('01-JAN-' || thisyear, 'DD-MON-YYYY')
            - TO_DATE('01-JAN-' || thisyear, 'DD-MON-YYYY');
        new_row.days_in_fis_year := new_row.days_in_cal_year;
        new_row.end_of_cal_year :=
            TO_DATE('01-JAN-' || thisyear, 'DD-MON-YYYY');
        new_row.end_of_fis_year :=
            TO_DATE('01-JAN-' || thisyear, 'DD-MON-YYYY');
        RETURN (new_row);
    END;

    FUNCTION getsourcedate(this_date      DATE,
                           source_year    NUMBER)
        RETURN DATE IS
        ddmon_part      VARCHAR2(6);
        v_source_date   DATE;
        leap_year_day exception;
        PRAGMA EXCEPTION_INIT(leap_year_day, -1839);
    BEGIN
        BEGIN
            ddmon_part := TO_CHAR(this_date, 'DD-MON');
            v_source_date :=
                TO_DATE(ddmon_part || '-' || source_year, 'DD-MON-YYYY');
        EXCEPTION
            WHEN leap_year_day -- If 28-Feb on non-leap year, then use 27-Feb
                              THEN
                ddmon_part := TO_CHAR(this_date - 1, 'DD-MON');
                v_source_date :=
                    TO_DATE(ddmon_part || '-' || source_year,
                    'DD-MON-YYYY');
        END;

        RETURN (v_source_date);
    END;

    PROCEDURE extend_partitions(table_name        VARCHAR2,
                                partition_year    NUMBER) IS
        TYPE vc_arr IS TABLE OF BOOLEAN
                           INDEX BY all_tab_partitions.partition_name%TYPE;

        part_list        vc_arr;
        partition_name   VARCHAR2(60);
        end_of_qtr       VARCHAR2(10);
        v_sql            VARCHAR2(200);
    BEGIN
        FOR r
        IN (SELECT partition_name
            FROM all_tab_partitions
            WHERE table_owner = 'SH' AND table_name = table_name) LOOP
            part_list(r.partition_name) := TRUE;
        END LOOP;

        FOR i IN 1 .. 4 LOOP
            partition_name :=
                UPPER(table_name) || '_Q' || i || '_' || partition_year;

            IF NOT part_list.EXISTS(partition_name) THEN
                end_of_qtr :=
                    CASE i
                        WHEN 1 THEN '01-MAR'
                        WHEN 2 THEN '30-JUN'
                        WHEN 3 THEN '30-SEP'
                        WHEN 4 THEN '31-DEC'
                    END;
                v_sql :=
                       'ALTER TABLE SH.'
                    || UPPER(table_name)
                    || ' ADD  PARTITION '
                    || partition_name
                    || ' VALUES LESS THAN (TO_DATE('''
                    || end_of_qtr
                    || '-'
                    || partition_year
                    || ' 23:59:59'',''DD-MON-YYYY HH24:MI:SS''))';

                EXECUTE IMMEDIATE v_sql;

                DBMS_OUTPUT.put_line('Creating ' || partition_name);
            END IF;
        END LOOP;
    END;

    PROCEDURE addsales(source_year    NUMBER,
                       target_year    NUMBER) IS
        v_yr_diff         NUMBER;
        v_start_date      DATE;
        v_end_date        DATE;
        v_this_date       DATE;
        v_source_date     DATE;
        v_time_row        sh.times%ROWTYPE;

        TYPE times_typ IS TABLE OF sh.times%ROWTYPE
                              INDEX BY BINARY_INTEGER;

        TYPE sales_typ IS TABLE OF sh.sales%ROWTYPE
                              INDEX BY BINARY_INTEGER;

        times_table       times_typ;
        sales_table_tmp   sales_typ;
        sales_table_all   sales_typ;
    BEGIN
        extend_partitions('SALES', target_year);
        extend_partitions('COSTS', target_year);
        v_yr_diff := target_year - source_year;
        v_start_date := TO_DATE('1-jan-' || target_year, 'DD-MON-YYYY');
        v_this_date := v_start_date;
        v_end_date := TO_DATE('31-dec-' || target_year, 'DD-MON-YYYY');

        WHILE (v_this_date <= v_end_date) LOOP
            v_source_date := getsourcedate(v_this_date, source_year);
            v_time_row := createtime(v_this_date, v_source_date);
            BEGIN
                INSERT INTO sh.times
                VALUES v_time_row;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    NULL;
            END;

            INSERT INTO sh.sales(prod_id, cust_id, time_id, channel_id, promo_id, quantity_sold, amount_sold)
                SELECT prod_id, cust_id, v_this_date, channel_id, promo_id,
                       quantity_sold, amount_sold
                FROM sh.sales
                WHERE time_id = v_source_date;

            INSERT INTO sh.costs(prod_id, time_id, promo_id, channel_id, unit_cost, unit_price)
                SELECT prod_id, v_this_date, promo_id, channel_id,
                       unit_cost, unit_price
                FROM sh.costs
                WHERE time_id = v_source_date;

            v_this_date := v_this_date + 1;
        END LOOP;
    /*  FORALL i IN 1 .. times_table.COUNT
         INSERT INTO sh.times
              VALUES times_table (i);*/
    END;
-- Enter further code below as specified in the Package spec.
END;