column owner format a12
column object_name format a20
column object_type format a20
column occurences format 999,999
column touches format 999,999,999

WITH cbc_latches AS 
    (SELECT addr, name, sleeps,
            rank() over(order by sleeps desc) ranking 
       FROM v$latch_children
      WHERE name = 'cache buffers chains')
SELECT owner, object_name,object_type,COUNT(*) occurences,sum(tch) touches
  FROM cbc_latches l JOIN x$bh b
       ON (l.addr = b.hladdr)
  JOIN dba_objects o
       ON (b.obj = o.object_id)
 WHERE l.ranking <=5 
 GROUP BY owner, object_name,object_type
ORDER BY count(*) DESC;  
 
