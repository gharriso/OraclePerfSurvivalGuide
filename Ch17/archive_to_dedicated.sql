select * from v$archive_dest ;
alter system set log_archive_dest_10='location=/ora_arch' scope=both; 
select * from v$archive_dest ;
alter system switch logfile; 
