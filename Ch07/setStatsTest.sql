/* Formatted on 2008/09/09 21:03 (Formatter Plus v4.8.7) */
SPOOL set_stats_test
DROP TABLE employees_test;
CREATE TABLE employees_test AS SELECT * FROM hr.employees where manager_id=100;

CREATE INDEX employees_test_i1 ON employees_test(manager_id);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'EMPLOYEES_TEST',
                                  method_opt      => 'FOR ALL COLUMNS SIZE 1'
                                 );
END;
/
alter system flush shared_pool; 

set autotrace on 

SELECT *
  FROM employees_test
 WHERE manager_id = 100;
 
 set autotrace off
 
SELECT num_distinct, density 
  FROM all_tab_col_statistics s 
 WHERE owner = USER
   AND table_name = 'EMPLOYEES_TEST'
   AND column_name = 'MANAGER_ID';
   
   select * from all_tab_statistics  WHERE owner = USER
   AND table_name = 'EMPLOYEES_TEST'; 

BEGIN

   DBMS_STATS.set_table_stats (ownname      => USER,
                               tabname      => 'EMPLOYEES',
                               numrows      => 10000,
                               numblks=>500
                              );
      DBMS_STATS.set_column_stats (ownname      => USER,
                                tabname      => 'EMPLOYEES',
                                colname      => 'MANAGER_ID',
                                distcnt      => 200,
                                density      => 0.005
                               );
END;
/
alter system flush shared_pool; 

set autotrace on 

SELECT *
  FROM employees_test
 WHERE manager_id = 100;
 
set autotrace off 
 
SELECT num_distinct, density
  FROM all_tab_col_statistics
 WHERE owner = USER
   AND table_name = 'EMPLOYEES_TEST'
   AND column_name = 'MANAGER_ID';
   
exit; 

