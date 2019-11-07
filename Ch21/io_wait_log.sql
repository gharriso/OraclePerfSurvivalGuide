create table io_wait_log as 
select * from opsg_delta_report where stat_name='db file sequential read'; 
