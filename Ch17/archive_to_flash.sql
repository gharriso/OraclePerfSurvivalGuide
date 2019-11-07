select * from v$archive_dest ;
alter system set log_archive_dest_10='location=USE_DB_RECOVERY_FILE_DEST' scope=both; 
select * from v$archive_dest ;
alter system switch logfile; 
