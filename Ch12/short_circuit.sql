/* Formatted on 9/12/2008 4:57:20 PM (QP5 v5.115.810.9015) */
var sid number ;

BEGIN
   SELECT   sid
     INTO   :sid
     FROM   v$session
    WHERE   audsid = USERENV ('sessionid');
END;
/

SELECT   'PLSQL time initial',value 
  FROM   v$sess_time_model
 WHERE   stat_name = 'PL/SQL execution elapsed time' AND sid = :sid;

DECLARE
   TYPE time_typ
   IS
      TABLE OF sales.time_id%TYPE
         INDEX BY BINARY_INTEGER;

   TYPE amt_typ
   IS
      TABLE OF sales.amount_sold%TYPE
         INDEX BY BINARY_INTEGER;

   t_time_id       time_typ;
   t_amount_sold   amt_typ;
BEGIN
   SELECT   time_id, amount_sold
     BULK   COLLECT
     INTO   t_time_id, t_amount_sold
     FROM   sales;

   FOR i IN t_time_id.FIRST .. t_time_id.LAST
   LOOP
      IF  t_amount_sold (i) > 1 AND t_time_id (i) < '01-JUN-98' 
      THEN
         -- do something
         NULL;
      END IF;
   END LOOP;
END;
/

SELECT   'Most likely first ',value 
  FROM   v$sess_time_model
 WHERE   stat_name = 'PL/SQL execution elapsed time' AND sid = :sid;
 
 DECLARE
   TYPE time_typ
   IS
      TABLE OF sales.time_id%TYPE
         INDEX BY BINARY_INTEGER;

   TYPE amt_typ
   IS
      TABLE OF sales.amount_sold%TYPE
         INDEX BY BINARY_INTEGER;

   t_time_id       time_typ;
   t_amount_sold   amt_typ;
BEGIN
   SELECT   time_id, amount_sold
     BULK   COLLECT
     INTO   t_time_id, t_amount_sold
     FROM   sales;

   FOR i IN t_time_id.FIRST .. t_time_id.LAST
   LOOP
      IF t_time_id (i) < '01-JUN-98' AND t_amount_sold (i) > 1
      THEN
         -- do something
         NULL;
      END IF;
   END LOOP;
END;
/

SELECT   'Least likely first',value 
  FROM   v$sess_time_model
 WHERE   stat_name = 'PL/SQL execution elapsed time' AND sid = :sid;
