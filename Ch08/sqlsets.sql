/* Formatted on 2008/09/16 15:05 (Formatter Plus v4.8.7) */
set echo on 
set lines 120 
set pages 1000
spool sqlsets

BEGIN
   DBMS_SQLTUNE.drop_sqlset (sqlset_name => 'Guy_STS12');
   DBMS_SQLTUNE.drop_sqlset (sqlset_name => 'MySqlSet');
   
   DBMS_SQLTUNE.create_sqlset (sqlset_name      => 'MySqlSet',
                               description      => 'SQL Tuning set demonstration'
                              );
END;
/

/*
-- Top 10 logical reads SQL first parsed by TRANSIM
SELECT *
  FROM TABLE
          (DBMS_SQLTUNE.select_cursor_cache
                           (basic_filter          => 'parsing_schema_name=''TRANSIM''',
                            ranking_measure1      => 'buffer_gets',
                            result_limit          => 10,
                            attribute_list        => 'ALL'
                           )
          );

SELECT MIN (snap_id), MAX (snap_id)
  FROM dba_hist_snapshot;

SELECT *
  FROM TABLE
          (DBMS_SQLTUNE.select_workload_repository
                           (1,
                            42,
                            basic_filter          => 'parsing_schema_name=''TRANSIM''',
                            ranking_measure1      => 'buffer_gets',
                            result_limit          => 10,
                            attribute_list        => 'ALL'
                           )
          );*/


DECLARE
   sqlset_csr   DBMS_SQLTUNE.sqlset_cursor;
BEGIN

   DBMS_SQLTUNE.create_sqlset (sqlset_name      => 'MySqlSet',
        description      => 'SQL Tuning set demonstration');
        
   OPEN sqlset_csr FOR
      SELECT VALUE (cache_sqls)
        FROM TABLE
                (DBMS_SQLTUNE.select_cursor_cache
                   (basic_filter          => 'parsing_schema_name=''TRANSIM''',
                    ranking_measure1      => 'buffer_gets',
                    result_limit          => 10)) cache_sqls;

   DBMS_SQLTUNE.load_sqlset (sqlset_name          => 'MySqlSet',
                             populate_cursor      => sqlset_csr);

   CLOSE sqlset_csr;
END;
/

DECLARE
   min_snap_id   NUMBER;
   max_snap_id   NUMBER;
   sqlset_csr    DBMS_SQLTUNE.sqlset_cursor;
BEGIN
   SELECT MIN (snap_id), MAX (snap_id)
     INTO min_snap_id, max_snap_id
     FROM dba_hist_snapshot;

   OPEN sqlset_csr FOR
      SELECT VALUE (workload_sqls)
        FROM TABLE
                (DBMS_SQLTUNE.select_workload_repository
                   (min_snap_id,
                    max_snap_id,
                    basic_filter      => 'parsing_schema_name=''TRANSIM''')
                ) workload_sqls;

   DBMS_SQLTUNE.load_sqlset (sqlset_name          => 'MySqlSet',
                             populate_cursor      => sqlset_csr,
                             load_option          => 'MERGE' );

   CLOSE sqlset_csr;
END;
/
SELECT SUBSTR (vs.sql_text, 1, 65) AS sql_text, dss.buffer_gets
  FROM dba_sqlset_statements dss JOIN v$sql vs USING (sql_id)
 WHERE sqlset_name = 'MySqlSet'
 /

