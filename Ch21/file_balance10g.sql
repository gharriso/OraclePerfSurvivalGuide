select singleblkrdtim*10/singleblkrds from v$filestat join dba_data_files on (file#=file_id)
 where tablespace_name='MIXED_DEVICES' 
