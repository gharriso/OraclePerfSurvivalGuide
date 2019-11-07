select name||'='||value from v$parameter where name like 'filesystemio_options';
alter system set filesystemio_options='none' scope=spfile;
select name||'='||value from v$parameter where name like 'filesystemio_options';
select name||'='||value from v$parameter where name like '%async%';
select filetype_name,asynch_io,count(*) from v$iostat_file group by filetype_name,asynch_io; 


