DROP TABLE fibonacci_results;

CREATE TABLE fibonacci_results (LIMIT       NUMBER,
                                recursive   NUMBER,
                                starttime   NUMBER,
                                endtime     NUMBER,
                                elapsed     NUMBER);

CREATE OR REPLACE FUNCTION mydbtime (p_sid NUMBER)
   RETURN NUMBER
IS
   v_dbtime   NUMBER;
BEGIN
   SELECT   VALUE
     INTO   v_dbtime
     FROM   v$sess_time_model
    WHERE   sid = p_sid AND stat_name = 'DB time';

   RETURN (v_dbtime);
END;
/

CREATE OR REPLACE PROCEDURE recursive_fibonacci (p_limit NUMBER)
IS
BEGIN
   IF p_limit > 1
   THEN
      recursive_fibonacci (p_limit - 1);
   END IF;

   DBMS_OUTPUT.put_line (p_limit || ' ' || TO_CHAR (p_limit + p_limit - 1));
END;
/

CREATE OR REPLACE PROCEDURE nonrecursive_fibonacci (p_limit NUMBER)
IS
BEGIN
   FOR i IN 1 .. p_limit
   LOOP
      DBMS_OUTPUT.put_line (i || ' ' || TO_CHAR (i + i - 1));
   END LOOP;
END;
/

DECLARE
   starttime         NUMBER;
   endtime           NUMBER;
   elapsed           NUMBER;
   v_sid             NUMBER;
   v_iterations      NUMBER := 10;
   v_max_fib         NUMBER := 1000000;
   v_min_fib         NUMBER := 10000;
   v_fib_increment   NUMBER := 5000;
   i                 NUMBER := 0;
BEGIN
   SELECT   sid
     INTO   v_sid
     FROM   v$session
    WHERE   audsid = USERENV ('sessionid');

   i := v_min_fib;

   WHILE i < v_max_fib
   LOOP
      starttime := DBMS_UTILITY.get_time ();

      FOR j IN 1 .. v_iterations
      LOOP
         recursive_fibonacci (i);
      END LOOP;

      endtime := DBMS_UTILITY.get_time ();


      INSERT INTO fibonacci_results
        VALUES   (i, 1, starttime, endtime, endtime - starttime);

      starttime := DBMS_UTILITY.get_time ();


      FOR j IN 1 .. v_iterations
      LOOP
         nonrecursive_fibonacci (i);
      END LOOP;

      endtime := DBMS_UTILITY.get_time ();


      INSERT INTO fibonacci_results
        VALUES   (i, 0, starttime, endtime, endtime - starttime);

      i := i + v_fib_increment;
   END LOOP;
END;
/

set pagesize 0

  SELECT   LIMIT || ',' || recursive || ',' || elapsed
    FROM   fibonacci_results
ORDER BY   LIMIT, recursive;

exit;
/* Formatted on 11/12/2008 9:22:53 PM (QP5 v5.120.811.25008) */
