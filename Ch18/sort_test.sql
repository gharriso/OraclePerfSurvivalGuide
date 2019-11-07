alter table txn_data parallel(degree 1); 
SELECT *
FROM (SELECT *
      FROM txn_data
      WHERE ROWNUM < 10000000
      ORDER BY tdata DESC,txn_id DESC, datetime)
WHERE ROWNUM < 10;
 
SELECT SUM(DECODE(name, 'session pga memory', VALUE/1048576)) pga_memory,
       SUM(DECODE(name, 'session pga memory max', VALUE/1048576)) pga_memory_max
FROM    v$mystat
     JOIN
        v$statname
     USING (statistic#)
WHERE name LIKE '%pga%'; 
