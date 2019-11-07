create tablespace mixed_devices datafile '+DATA03_SLOW' size 500m; 
alter tablespace mixed_devices add datafile '+DATA04_MIXED' size 500m;
alter tablespace mixed_devices add datafile '+DATA01_WIDE' size 500m;
alter tablespace mixed_devices add datafile '+DATA03_SLOW' size 500m; 
alter tablespace mixed_devices add datafile '+DATA04_MIXED' size 500m;
alter tablespace mixed_devices add datafile '+DATA01_WIDE' size 500m; 
alter tablespace mixed_devices add datafile '+DATA03_SLOW' size 500m; 
alter tablespace mixed_devices add datafile '+DATA04_MIXED' size 500m;
alter tablespace mixed_devices add datafile '+DATA01_WIDE' size 500m; 

select * from v$asm_diskgroup;
