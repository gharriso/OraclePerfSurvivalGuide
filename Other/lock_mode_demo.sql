var mysid number
column lock_mode format a12
set echo on 

BEGIN
   SELECT sid
   INTO :mysid
   FROM v$session
   WHERE audsid = USERENV('sessionid');
END;
/

COMMIT;

UPDATE customers
SET cust_valid = 'Y'
WHERE cust_id = 49671;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;

SELECT *
FROM customers
WHERE cust_id = 49671
FOR UPDATE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;

LOCK TABLE customers IN EXCLUSIVE MODE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;
LOCK TABLE table IN SHARE ROW EXCLUSIVE MODE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

s
/* Formatted on 23-Jan-2009 16:52:41 (QP5 v5.120.811.25008) */
