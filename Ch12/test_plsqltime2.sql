/* Formatted on 2008/10/04 17:10 (Formatter Plus v4.8.7) */
DECLARE
   x   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO x
     FROM sh.sales;
END;
/

@@plsqltime
EXIT;

