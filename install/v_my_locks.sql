create or replace view v_my_locks as 
SELECT TYPE,name,
       lock_mode(lmode) lock_mode , id1, id2, lmode, DECODE(TYPE, 'TM',
                                     (SELECT object_name
                                      FROM dba_objects
                                      WHERE object_id = id1))
                                        table_name
FROM v$lock join v$lock_type using (type) 
WHERE sid = (SELECT sid
             FROM v$session
             WHERE audsid = USERENV('sessionid'))
  and type <> 'AE';
/* Formatted on 21-Jan-2009 15:26:02 (QP5 v5.120.811.25008) */
