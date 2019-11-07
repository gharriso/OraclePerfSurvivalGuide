@echo off

if (%1) == () goto usage
SET /a i=1
set bind=true 
sqlplus -S %1 @query_loops_proc
sqlplus -S %1 @spin_count 2
:loop
    SET /a i=%i%+1
    start sqlplus -S %1 @query_loops %2 %3 %bind% false false false false  false
    echo %i%
   IF %i%==%4 GOTO ENDL
GOTO LOOP
:endl
sqlplus -S %1 @query_loops %2 %3 %bind% false false false false  false

goto end

:usage
echo "Usage: cbc_contention user/pass@db seconds row_range processes
goto end 

:end 
