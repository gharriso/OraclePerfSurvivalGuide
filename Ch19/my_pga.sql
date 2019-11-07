SELECT SUM(DECODE(name, 'session pga memory', VALUE)) pga_memory,
       SUM(DECODE(name, 'session pga memory max', VALUE)) pga_memory_max
FROM    v$mystat
     JOIN
        v$statname
     USING (statistic#)
WHERE name LIKE '%pga%'
/* Formatted on 28/02/2009 11:02:35 AM (QP5 v5.120.811.25008) */
