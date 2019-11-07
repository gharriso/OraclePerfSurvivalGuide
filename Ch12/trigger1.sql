spool trigger1
set pages 1000
set lines 120
set echo on
set timing on
set serveroutput on 

DROP TABLE sales;

CREATE TABLE sales
AS
   SELECT   * FROM sh.sales;

set autotrace on



DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/

/* Formatted on 14/12/2008 1:40:28 PM (QP5 v5.120.811.25008) */

DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/

CREATE OR REPLACE FUNCTION sales_discount (p_amount_sold NUMBER)
   RETURN NUMBER
IS
   x   NUMBER := 0;
BEGIN
   FOR i IN 1 .. 1000
   LOOP
      x := x + i;
   END LOOP;

   RETURN (p_amount_sold);
END;
/

CREATE OR REPLACE TRIGGER sales_upd
   BEFORE UPDATE OR INSERT
   ON sales
   FOR EACH ROW
DECLARE
   v_adjusted_amount   sales.amount_sold%TYPE;
BEGIN
   v_adjusted_amount := sales_discount (:new.amount_sold);
   IF :new.amount_sold > 1500
   THEN
      :new.amount_sold := v_adjusted_amount;
   END IF;
END;
/

set timing on
set autotrace on

DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/
DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/


CREATE OR REPLACE TRIGGER sales_upd
   BEFORE UPDATE OF amount_sold OR INSERT
   ON sales
   FOR EACH ROW
   WHEN (new.amount_sold > 1500)
DECLARE
   v_adjusted_amount   sales.amount_sold%TYPE;
BEGIN
   v_adjusted_amount := sales_discount (:new.amount_sold);
   IF :new.amount_sold > 1500
   THEN
      :new.amount_sold := v_adjusted_amount;
   END IF;
END;
/

DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/
DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/

drop trigger sales_upd;
 
DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/
DECLARE
   v_start   NUMBER;
BEGIN
   v_start := DBMS_UTILITY.get_time ();

   UPDATE   sales
      SET   amount_sold = amount_sold
    WHERE   MOD (prod_id, 45) = 0;

   UPDATE   sales
      SET   quantity_sold = quantity_sold
    WHERE   MOD (prod_id, 45) = 0;

   COMMIT;
   DBMS_OUTPUT.put_line (
      'Elapsed time: ' || ( DBMS_UTILITY.get_time () - v_start));
END;
/
exit;
/* Formatted on 14/12/2008 1:19:00 PM (QP5 v5.120.811.25008) */
