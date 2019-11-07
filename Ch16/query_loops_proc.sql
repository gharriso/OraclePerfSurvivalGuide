create or replace 
PROCEDURE query_loops(run_seconds      NUMBER,
                      hi_val           NUMBER,
                      use_binds        BOOLEAN := TRUE,
                      reset_cache      BOOLEAN := FALSE,
                      reset_pool       BOOLEAN := FALSE,
                      round_lookups    BOOLEAN := TRUE,
                      range_query      boolean := false ) AS
   v_data         log_data.data%TYPE;
   v_id           log_data.id%TYPE;
   v_start_time   NUMBER;
   v_elapsed_time number; 
   i              NUMBER := 1;
   v_operator     varchar2(1):='='; 
BEGIN
   v_start_time := DBMS_UTILITY.get_time();
   IF reset_cache THEN
      EXECUTE IMMEDIATE 'alter system flush buffer_cache';
   END IF;
   IF reset_pool THEN
      EXECUTE IMMEDIATE 'alter system flush shared_pool';
   END IF;
    if range_query then 
        v_operator:='<';
    end if; 
   LOOP
      i := i + 1;
      IF Round_lookups THEN
         v_id := ROUND(DBMS_RANDOM.VALUE(1, hi_val));
      ELSE
         v_id := DBMS_RANDOM.VALUE(1, hi_val);
      END IF;
      begin 
      IF use_binds THEN
         EXECUTE IMMEDIATE 'select max(data) from log_data where id'||v_operator||':id'  
            INTO v_data
            USING v_id;
      ELSE
         EXECUTE IMMEDIATE 'select max(data) from log_data where id'||v_operator || v_id
            INTO v_data;
      END IF;
      exception when no_data_found then null;
      end; 
      IF (MOD(i, 100) = 0) THEN
         v_elapsed_time:=(DBMS_UTILITY.get_time() - v_start_time) / 100; 
         IF (v_elapsed_time > run_seconds) THEN
            EXIT;
         END IF;
      END IF;
   END LOOP;
END;
/
exit
