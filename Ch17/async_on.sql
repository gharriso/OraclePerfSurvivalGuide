select name||'='||value from v$parameter where name like 'filesystemio_options';
alter system set filesystemio_options='none' scope=spfile;
select name||'='||value from v$parameter where name like 'filesystemio_options';


