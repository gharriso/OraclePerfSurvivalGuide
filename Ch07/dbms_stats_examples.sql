/* Formatted on 2008/09/09 22:26 (Formatter Plus v4.8.7) */
DROP TABLE employees;
CREATE TABLE employees AS SELECT * FROM hr.employees;



BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'EMPLOYEES');
   DBMS_STATS.gather_schema_stats (ownname => 'HR');
   DBMS_STATS.gather_schema_stats (ownname      => 'HR',
                                   options      => 'GATHER STALE');
   DBMS_STATS.gather_schema_stats
                           (ownname         => 'HR',
                            method_opt      => 'FOR ALL INDEXED COLUMNS SIZE AUTO'
                           );
   DBMS_STATS.set_database_prefs
                            (pname       => 'METHOD_OPT',
                             pvalue      => 'FOR ALL INDEXED COLUMNS SIZE SKEWONLY'
                            );
                            
    
END;

BEGIN
   DBMS_STATS.create_stat_table (ownname => USER, stattab => 'GuysStatTab');
   DBMS_STATS.export_table_stats (ownname      => USER,
                                  tabname      => 'EMPLOYEES',
                                  stattab      => 'GuysStatTab',
                                  statid       => 'Demo1'
                                 );
END;

BEGIN
   DBMS_STATS.import_table_stats (ownname      => USER,
                                  tabname      => 'EMPLOYEES',
                                  stattab      => 'GuysStatTab',
                                  statid       => 'Demo1'
                                 );
END;

/* Formatted on 2008/09/09 22:44 (Formatter Plus v4.8.7) */
BEGIN
   DBMS_STATS.set_schema_prefs (ownname      => 'HR',
                                pname        => 'STALE_PERCENT',
                                pvalue       => 20
                               );
END;


