var mysid number
set lines 100
set pages 10000

column lock_mode format a24
column type format a4
column name format a16 
column table_name format a20

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

UPDATE customers
   SET cust_valid = 'Y'
 WHERE cust_id = 100667;

UPDATE sales
   SET channel_id = 2
 WHERE cust_id = 100667;
 

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

ROLLBACK;
 

SELECT *
FROM customers
WHERE cust_id = 49671
FOR UPDATE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;

SELECT *
FROM customers
WHERE cust_id = 49671
FOR  UPDATE SHARE ;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;

LOCK TABLE customers IN EXCLUSIVE MODE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;
LOCK TABLE customers  IN SHARE ROW EXCLUSIVE MODE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

COMMIT;
LOCK TABLE customers  IN EXCLUSIVE MODE;

SELECT TYPE, name, lock_mode, table_name FROM v_my_locks;

s
/* Formatted on 23-Jan-2009 16:52:41 (QP5 v5.120.811.25008) */
