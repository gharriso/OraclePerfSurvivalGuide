CREATE OR REPLACE PACKAGE use_uga IS
   t_datetime   DBMS_SQL.date_table;
   t_tdata      DBMS_SQL.varchar2_table;
   PROCEDURE use_uga(rows            NUMBER,
                     time_minutes    NUMBER := NULL);
END;
/

CREATE OR REPLACE PACKAGE BODY use_uga IS
   PROCEDURE use_uga(rows            NUMBER,
                     time_minutes    NUMBER := NULL) IS
   BEGIN
      SELECT tdata, datetime
      BULK COLLECT
      INTO t_tdata, t_datetime
      FROM txn_data
      WHERE ROWNUM < rows;

      IF (time_minutes IS NOT NULL) THEN
         sys.DBMS_LOCK.sleep(time_minutes * 60);
      END IF;
   END;
END;
/ 
