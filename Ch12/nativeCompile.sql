/* Formatted on 2008/09/21 01:38 (Formatter Plus v4.8.7) */
SET timing on
set serveroutput on 
alter system set plsql_optimize_level=1 scope=memory; 
alter session set tracefile_identifier=nativeCompile;
alter session set sql_trace true; 

drop function time_sales; 
drop function nprimes1; 
drop function nprimes_comp; 

var nprimes_val number;
var times_sales_val number;

begin 
    :nprimes_val:=4000;
    :times_sales_val:=4000;
end;
/

alter session set  plsql_code_type = 'INTERPRETED';   /* vs. 'INTERPRETED' */

CREATE OR REPLACE FUNCTION time_sales (p_days NUMBER)
   RETURN NUMBER
IS
   v_amount_sold   NUMBER;
BEGIN
   SELECT SUM (amount_sold)
     INTO v_amount_sold
     FROM sh.sales
    WHERE time_id>sysdate-numtodsinterval(p_days,'DAY'); 
    return(v_amount_sold); 
END;
/

CREATE OR REPLACE FUNCTION nprimes1 (p_num NUMBER)
   RETURN NUMBER
IS
   i         INT;
   j         INT;
   nprimes   INT;
   isprime   INT;
BEGIN
   i := 2;
   nprimes := 0;

   <<main_loop>>
   WHILE (i < p_num)
   LOOP
      isprime := 1;
      j := 2;

      <<divisor_loop>>
      WHILE (j < i)
      LOOP
         IF (MOD (i, j) = 0)
         THEN
            isprime := 0;
         --EXIT divisor_loop;
         END IF;

         j := j + 1;
      END LOOP;

      IF (isprime = 1)
      THEN
         nprimes := nprimes + 1;
      END IF;

      i := i + 1;
   END LOOP;

   RETURN (nprimes);
END;
/
alter function nprimes1 compile plsql_code_type=interpreted;
alter function time_sales compile plsql_code_type=interpreted;

col name format a30
col plsql_code_type format a30

select name,plsql_code_type
 from all_plsql_object_settings
where owner=user; 

BEGIN
   DBMS_OUTPUT.put_line ('Nprimes interpreted:'||nprimes1 (:nprimes_val));
END;
/
BEGIN
   DBMS_OUTPUT.put_line ('time_sales interpreted:'||time_sales(:times_sales_val));
END;
/
alter session  SET plsql_code_type = 'NATIVE'; 
alter function nprimes1 compile plsql_code_type=native;
alter function time_sales compile plsql_code_type=native;

CREATE OR REPLACE FUNCTION nprimes_comp (p_num NUMBER)
   RETURN NUMBER
IS
   i         INT;
   j         INT;
   nprimes   INT;
   isprime   INT;
BEGIN
   i := 2;
   nprimes := 0;

   <<main_loop>>
   WHILE (i < p_num)
   LOOP
      isprime := 1;
      j := 2;

      <<divisor_loop>>
      WHILE (j < i)
      LOOP
         IF (MOD (i, j) = 0)
         THEN
            isprime := 0;
         --EXIT divisor_loop;
         END IF;

         j := j + 1;
      END LOOP;

      IF (isprime = 1)
      THEN
         nprimes := nprimes + 1;
      END IF;

      i := i + 1;
   END LOOP;

   RETURN (nprimes);
END;
/
select name, plsql_code_type
 from all_plsql_object_settings
where owner=user; 

BEGIN
   DBMS_OUTPUT.put_line ('Nprimes compiled:'||nprimes_comp (:nprimes_val));
END;
/
BEGIN
   DBMS_OUTPUT.put_line ('time_sales compiled:'||time_sales(:times_sales_val));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Nprimes compiled:'||nprimes_comp (:nprimes_val));
END;
/
BEGIN
   DBMS_OUTPUT.put_line ('time_sales compiled:'||time_sales(:times_sales_val));
END;
/
