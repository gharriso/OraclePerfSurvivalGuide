/* Formatted on 2008/01/13 01:14 (Formatter Plus v4.8.7) */
set verify off

VAR id1 number
VAR id2 number

BEGIN
   SYS.DBMS_LOCK.sleep (&1);
END;
/

BEGIN
   :id1 := &2;
   :id2 := &3;
END;
/

UPDATE quest_soo_customers
   SET status = 'B'
 WHERE ID = :id1;

UPDATE quest_soo_customers
   SET status = 'C'
 WHERE ID = :id2;

BEGIN
   /* I'm going to lunch!! */
   FOR i IN 1 .. &4
   LOOP
      SYS.DBMS_LOCK.sleep (1);
   END LOOP;
END;
/

EXIT

