/* Formatted on 2008/09/06 12:46 (Formatter Plus v4.8.7) */
SET pages 10000
SET lines 120
SET echo on



VARIABLE v_country_id number;

BEGIN
   :v_country_id := 52790;                                              --USA
END;
/

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

SELECT SUBSTR (sql_text, 1, 20), sql_id, child_number, is_bind_sensitive,
       is_bind_aware
  FROM v$sql
 WHERE sql_text LIKE 'SELECT MA%v_country_id%';


BEGIN
   :v_country_id := 52787;                                     -- New Zealand
END;
/

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;

SELECT MAX (cust_income_level)
  FROM customers
 WHERE country_id = :v_country_id;


REM
REM Find the SQL_ID and child cursors for the SQL
REM
column is_bind_sensitive format a10
column is_bind_aware format a10 
SELECT sql_id, child_number,
       is_bind_sensitive, is_bind_aware
  FROM v$sql
 WHERE sql_text LIKE 'SELECT MA%v_country_id%';

REM
REM Display the child cursor
REM

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor 
             ('fru7mqzkt56zr', NULL, 'BASIC'));

EXIT;

