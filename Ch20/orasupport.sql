set pages 2000
spool oracle_support

alter system set "_memory_management_tracing"=64;

select (PGA_TARGET_FOR_ESTIMATE/1048576) pga_size, PGA_TARGET_FACTOR, 
ESTD_TIME t from v$pga_target_advice order by PGA_TARGET_FACTOR;

select SGA_SIZE s, SGA_SIZE_FACTOR f, ESTD_DB_TIME t, ESTD_PHYSICAL_READS r 
from v$sga_target_advice order by SGA_SIZE;

select MEMORY_SIZE MSIZE, MEMORY_SIZE_FACTOR MFACTOR, ESTD_DB_TIME TIME, 
VERSION from V$MEMORY_TARGET_ADVICE order by MEMORY_SIZE;

select MEMSZ, SGA_SZ, PGA_SZ, SGATIME, PGATIME, DBTIME from x$kmgsbsmemadv 
order by MEMSZ;

alter system set "_memory_management_tracing"=0;