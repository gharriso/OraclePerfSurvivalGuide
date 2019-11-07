CREATE OR REPLACE PACKAGE gen_hit_rate
  IS
 

     PROCEDURE read_stats(p_phys_reads   OUT NUMBER,
                          p_log_reads    OUT NUMBER,p_hit_rate out number) ; 

     PROCEDURE gen_hit_rate(p_hit_rate NUMBER) ;
     procedure gen_hit_rate(p_hit_rate number, runTimeMinutes number); 

     PROCEDURE gen_varying_load ;

END; 
/
CREATE OR REPLACE PACKAGE BODY gen_hit_rate IS
   g_phys_reads   NUMBER;
   g_log_reads    NUMBER;

   PROCEDURE LOG(p_text VARCHAR2) IS
   BEGIN
      INSERT INTO log_table
      VALUES (log_table_seq.NEXTVAL, p_text);

      COMMIT;
   END;
   /* return deltas for phys + log reads */
   PROCEDURE read_stats(p_phys_reads   OUT NUMBER,
                        p_log_reads    OUT NUMBER,
                        p_hit_rate     OUT NUMBER) IS
      v_log_reads    NUMBER;
      v_phys_reads   NUMBER;
   BEGIN
      SELECT SUM(DECODE(name, 'session logical reads', VALUE, 0)) logical_reads,
             SUM(DECODE(name, 'physical reads', VALUE, 0)) physical_reads
      INTO v_log_reads, v_phys_reads
      FROM sys.v_$sysstat
      WHERE name LIKE '%reads%';

      p_phys_reads := v_phys_reads - g_phys_reads;
      p_log_reads := v_log_reads - g_log_reads;
      IF p_log_reads > 0 THEN
         p_hit_rate := (p_log_reads - p_phys_reads) * 100 / p_log_reads;
      ELSE
         p_hit_rate := 0;
      END IF;
      g_phys_reads := v_phys_reads;
      g_log_reads := v_log_reads;
   --DBMS_OUTPUT.put_line(g_log_reads);
   --DBMS_OUTPUT.put_line(g_phys_reads);
   END;


   PROCEDURE runload(p_hit_rate       NUMBER,
                     p_end_id         NUMBER,
                     p_use_mi         BOOLEAN := FALSE,
                     p_runtime_min    NUMBER := NULL) IS
      v_batch_size   NUMBER := 1000;
      v_start_id     NUMBER := 1;
      v_id           NUMBER;
      v_end_id       NUMBER := 1000000;
      v_status       NUMBER;
      v_dummy        VARCHAR2(1000);
      v_phys_delta   NUMBER;
      v_log_delta    NUMBER;
      v_hit_rate     NUMBER;
      i              NUMBER;
      v_stable       BOOLEAN := FALSE;
      txn_row        txn_data%ROWTYPE;
      v_startTime    NUMBER;
      v_hit_target   NUMBER := 100;
   BEGIN
      EXECUTE IMMEDIATE 'alter system flush buffer_cache';

      EXECUTE IMMEDIATE 'truncate table log_table';

      DBMS_ALERT.REGISTER('GHR_STOP'); -- end run
      DBMS_ALERT.REGISTER('GHR_STABLE'); -- stop seeking hit rate
      DBMS_ALERT.REGISTER('GHR_SEEK'); -- start seeking
      read_stats(v_phys_delta, v_log_delta, v_hit_rate);
      i := 1;
      v_startTime := DBMS_UTILITY.get_time();

      IF (p_end_id IS NOT NULL) THEN
         v_end_id := p_end_id;
      END IF;
      IF (p_hit_rate IS NOT NULL) THEN
         v_hit_target := p_hit_rate;
      END IF;

      LOOP
         v_id := ROUND(DBMS_RANDOM.VALUE(v_start_id, v_end_id));
         BEGIN
            SELECT *
            INTO txn_row
            FROM txn_data
            WHERE txn_id = v_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
         END;
         IF MOD(i, v_batch_size) = 0 THEN
            -- Stop on alert
            DBMS_ALERT.waitone(NAME => 'GHR_STOP', status => v_status,
            MESSAGE => v_dummy, TIMEOUT => 0);
            IF v_status = 0 THEN
               LOG('v_end_id=' || v_end_id);
               LOG('last hit rate: ' || v_hit_rate);
               EXIT;
            END IF;

            IF (p_runtime_min IS NOT NULL) THEN
               IF ((DBMS_UTILITY.get_time() - v_startTime) / 100 >
                      p_runtime_min * 60) THEN
                  LOG('Timeout');
                  EXIT;
               END IF;
            END IF;
            DBMS_ALERT.waitone(NAME => 'GHR_STABLE', status => v_status,
            MESSAGE => v_dummy, TIMEOUT => 0);
            IF v_status = 0 THEN
               v_stable := TRUE;
               LOG('Stabalized at v_end_id=' || v_end_id);
            END IF;
            IF (p_end_id IS NULL) THEN
               IF (p_use_mi) THEN
                  -- set the target hit rate based on minute of hour
                  SELECT 100 - ABS(TO_NUMBER(TO_CHAR(SYSDATE, 'mi')) - 30)
                  INTO v_hit_target
                  FROM DUAL;

                  LOG('New hit rate target=' || v_hit_target);
               END IF;
               -- Adjust range of scans
               read_stats(v_phys_delta, v_log_delta, v_hit_rate);
               IF NOT v_stable THEN
                  IF v_hit_rate > v_hit_target * 1.01 THEN
                     v_end_id := ROUND(v_end_id * 1.1);
                  ELSIF v_hit_rate < v_hit_target * .95 THEN
                     v_end_id := ROUND(v_end_id * .9);
                  END IF;
                  LOG(   'v_hit_rate='
                      || v_hit_rate
                      || ' , v_end_id='
                      || v_end_id
                      || ', v_target='
                      || v_hit_target);
               END IF;
            END IF;
         END IF;
         i := i + 1;
      END LOOP;
   END;

   PROCEDURE gen_hit_rate(p_hit_rate NUMBER) IS
   BEGIN
      runload(p_hit_rate => p_hit_rate, p_end_id => NULL);
   END;

   PROCEDURE gen_static_load(p_end_id NUMBER) IS
   BEGIN
      runload(p_hit_rate => NULL, p_end_id => p_end_id);
   END;

   PROCEDURE gen_varying_load IS
   BEGIN
      runload(p_hit_rate => NULL, p_end_id => NULL, p_use_mi => TRUE);
   END;
   PROCEDURE gen_hit_rate(p_hit_rate        NUMBER,
                          runTimeMinutes    NUMBER) IS
   BEGIN
      runload(p_hit_rate => p_hit_rate, p_end_id => NULL,
      p_runtime_min => runTimeMinutes);
   END;
END;
/* Formatted on 24/02/2009 9:27:01 AM (QP5 v5.120.811.25008) */ 
/
