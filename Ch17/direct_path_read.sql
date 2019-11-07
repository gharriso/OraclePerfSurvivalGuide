alter session set "_serial_direct_read" = true; 
select /*+ full(d) */ max(datetime) from opsg2_log_data d; 
select * from my_wait_view; 

