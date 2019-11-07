ALTER TABLE txn_data PARALLEL(DEGREE 1);
EXPLAIN PLAN
   FOR

      SELECT /* noparallel(d) */
            MAX(tdata)
      FROM txn_data d
      WHERE ROWNUM < 1000000;


SELECT * FROM table(DBMS_XPLAN.display());

CREATE or replace PROCEDURE sort_sizes(min_rows      NUMBER,
                            max_rows      NUMBER,
                            iterations    NUMBER) IS
   v_rows   NUMBER;
BEGIN
   v_rows := ROUND(DBMS_RANDOM.VALUE(min_rows, max_rows));

   FOR i IN 1 .. iterations LOOP
      FOR r IN (SELECT *
                FROM txn_data
                WHERE rownum < v_rows
                ORDER BY tdata, datetime) LOOP
         NULL;
      END LOOP;
   END LOOP;
END;

