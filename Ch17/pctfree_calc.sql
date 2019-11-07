set echo on 

SELECT block_size, avg_row_len,
       ROUND(avg_row_len * 100 / block_size, 2) 
          row_pct_of_block
  FROM user_tablespaces
  JOIN user_tables
  USING (tablespace_name)
WHERE table_name = 'BB_DATA';
 
