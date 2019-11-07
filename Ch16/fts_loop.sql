ALTER SYSTEM FLUSH BUFFER_CACHE;

DECLARE
   x      log_data%ROWTYPE;
   v_id   NUMBER;
BEGIN
   FOR i IN 1 .. 9000000 LOOP
      v_id := ROUND(DBMS_RANDOM.VALUE(1, 9000000));

      SELECT *
      INTO x
      FROM log_data
      WHERE id = v_id;
   END LOOP;
END;
/

/* Formatted on 2-Feb-2009 22:36:59 (QP5 v5.120.811.25008) */
