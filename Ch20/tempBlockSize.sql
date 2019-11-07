set echo on 

SELECT tablespace_name, block_size
FROM dba_tablespaces
WHERE contents = 'TEMPORARY'
