select file#,singleblkrdtim_milli,singleblkrds /* ,sum(singlblkrds) over(partition by file#)*/ from v$file_histogram      JOIN
        dba_data_files
     ON (file#= file_id)
WHERE tablespace_name = 'MIXED_DEVICES'
