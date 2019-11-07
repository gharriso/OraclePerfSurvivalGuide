SELECT small_sync_read_latency/SMALL_SYNC_READ_REQS
FROM    v$iostat_file
     JOIN
        dba_data_files
     ON (file_no = file_id)
WHERE filetype_name = 'Data File' AND tablespace_name = 'MIXED_DEVICES'
