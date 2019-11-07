UPDATE customers
SET cust_valid = 'Y'
WHERE cust_id = 49671;

SELECT TYPE,lock_name,
       DECODE(lmode,
              1, NULL,
              2, 'Row Share (SS)',
              3, 'Row Exclusive (SX)',
              4, 'Share (S)',
              5, 'Shared Row Exclusive (SSX)',
              6, 'Exclusive (X)',
              ' ') lock_mode , id1, id2, lmode, DECODE(TYPE, 'TM',
                                     (SELECT object_name
                                      FROM dba_objects
                                      WHERE object_id = id1))
                                        table_name
FROM v$lock join v$lock_type using (type) 
WHERE sid = (SELECT sid
             FROM v$session
             WHERE audsid = USERENV('sessionid'));
/* Formatted on 21-Jan-2009 15:26:02 (QP5 v5.120.811.25008) */
