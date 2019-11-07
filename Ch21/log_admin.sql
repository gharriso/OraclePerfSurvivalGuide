alter database add logfile '/oraredo/gec2f/redo01e.log' size 20m ; 
alter database add logfile '/oraredo/gec2f/redo01f.log' size 20m ; 
alter database add logfile '/oraredo/gec2f/redo01g.log' size 20m ; 
alter database add logfile '/oraredo/gec2f/redo01h.log' size 5m ; 
alter database add logfile '/oraredo/gec2f/redo01i.log' size 5m ;
alter system switch logfile;
alter system checkpoint;  
 alter database drop logfile '/oraredo/gec2f/redo01e.log';  
  alter database drop logfile '/oraredo/gec2f/redo01f.log';  
    alter database drop logfile '/oraredo/gec2f/redo01g.log';
select * from v$logfile join v$log using (group#) 
