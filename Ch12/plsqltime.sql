col db_time_secs format 999,999,999.99
col plsql_time_secs format 999,999,999.99
col pct_plsql_time format 99.99

WITH plsql_times AS
     (
        SELECT SUM (DECODE (stat_name, 'DB time', VALUE/1000000, 0)) db_time , 
               SUM (DECODE (stat_name,
                            'PL/SQL execution elapsed time', VALUE/1000000, 0 )
                   ) plsql_time
          FROM v$sess_time_model
         WHERE SID = (SELECT SID
                        FROM v$session
                       WHERE audsid = USERENV ('sessionid'))
           AND stat_name IN
                  ('DB time','PL/SQL execution elapsed time'))
SELECT round(db_time,2) db_time_secs, round(plsql_time,2) plsql_time_secs,
       ROUND (plsql_time * 100 / db_time, 2) pct_plsql_time
  FROM plsql_times
/

