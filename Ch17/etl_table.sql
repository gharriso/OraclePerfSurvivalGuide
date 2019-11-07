DROP TABLE log_etlfile_117;

CREATE TABLE log_etlfile_117
STORAGE(BUFFER_POOL KEEP)
NOLOGGING
PARALLEL(DEGREE 4) AS
   SELECT /*+ parallel(d,4)*/ *
   FROM log_data d
   WHERE ROWNUM < &1;
   
alter table log_etlfile_117 parallel(degree 1); 
 
