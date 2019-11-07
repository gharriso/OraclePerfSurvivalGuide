
BEGIN
   sys.dbms_stats.gather_schema_stats(OWNNAME=>user);
END;
select blocks,round(blocks*8196/104857600,2) mb100, num_rows, s.* from user_tables s ; 
