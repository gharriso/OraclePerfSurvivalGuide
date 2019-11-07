/* Formatted on 9/12/2008 4:57:20 PM (QP5 v5.115.810.9015) */
var sid number ;
set serveroutput on ; 

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
   v_time_category number; 
   v_sum_cat number:=0; 
BEGIN
   SELECT   time_id, amount_sold
     BULK   COLLECT
     INTO   t_time_id, t_amount_sold
     FROM   sales;

   FOR i IN t_time_id.FIRST .. t_time_id.LAST
   LOOP
      IF   t_time_id (i) < '01-JUN-98'  then 
        v_time_category:=1; 
      ELSIF t_time_id(i) < '01-JUN-99' then 
        v_time_category:=2; 
      ELSE 
        v_time_category:=3;    
      END IF;
      
      v_sum_cat:=v_sum_cat+v_time_category; 
   END LOOP;
   dbms_output.put_line(v_sum_cat);
END;
/

SELECT   'Least likely first',value 
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
   v_time_category number; 
   v_sum_cat number:=0; 
BEGIN
   SELECT   time_id, amount_sold
     BULK   COLLECT
     INTO   t_time_id, t_amount_sold
     FROM   sales;

   FOR i IN t_time_id.FIRST .. t_time_id.LAST
   LOOP
      IF   t_time_id (i) >= '01-JUN-99'  then 
        v_time_category:=3; 
      ELSIF t_time_id(i) >= '01-JUN-98' then 
        v_time_category:=2; 
      ELSE 
        v_time_category:=1;    
      END IF;
      
      v_sum_cat:=v_sum_cat+v_time_category; 
   END LOOP;
   dbms_output.put_line(v_sum_cat);
END;
/ 

SELECT   'Most Likely first',value 
  FROM   v$sess_time_model
 WHERE   stat_name = 'PL/SQL execution elapsed time' AND sid = :sid;
