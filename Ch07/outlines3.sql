/* Formatted on 2008/09/11 12:18 (Formatter Plus v4.8.7) */
/* Demo of stabalizing a plan with an outline */

SPOOL outline_editing
set lines 100 
set pages 1000

DROP TABLE customers;
CREATE TABLE customers AS SELECT * FROM sh.customers;

column ol_name format a20 
column hint_text format a40

CREATE INDEX cust_year_of_birth_idx ON customers(cust_year_of_birth);

BEGIN
   DBMS_STATS.gather_table_stats (ownname         => USER,
                                  tabname         => 'CUSTOMERS',
                                  method_opt      => 'FOR ALL INDEXED COLUMNS'
                                 );
END;
/

SET echo on
SET pages 10000
SET lines 120


BEGIN
   FOR r IN (SELECT NAME
               FROM dba_outlines)
   LOOP
      EXECUTE IMMEDIATE 'Drop outline ' || r.NAME;
   END LOOP;

   FOR r IN (SELECT ol_name
               FROM ol$)
   LOOP
      EXECUTE IMMEDIATE 'Drop private outline ' || r.ol_name;
   END LOOP;
END;
/

CREATE  OUTLINE cust_yob_otln FOR CATEGORY outlines2 ON
SELECT MIN(cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;



CREATE PRIVATE OUTLINE original_oln FROM cust_yob_otln;

CREATE  PRIVATE OUTLINE hinted_oln  ON
SELECT /*+ INDEX(C) */ MIN(cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

SELECT ol_name, hint_text
  FROM ol$hints;

UPDATE ol$hints
   SET ol_name =
          CASE ol_name
             WHEN 'HINTED_OLN'
                THEN 'ORIGINAL_OLN'
             WHEN 'ORIGINAL_OLN'
                THEN 'HINTED_OLN'
             ELSE ol_name
          END
 WHERE ol_name IN ('HINTED_OLN', 'ORIGINAL_OLN');

UPDATE ol$ ol1
   SET hintcount =
          (SELECT hintcount
             FROM ol$ ol2
            WHERE ol2.ol_name IN ('HINTED_OLN', 'ORIGINAL_OLN')
              AND ol2.ol_name != ol1.ol_name)
 WHERE ol1.ol_name IN ('HINTED_OLN', 'ORIGINAL_OLN');
COMMIT ;

SELECT ol_name, hint_text
  FROM ol$hints
  order by ol_name, hint#;

BEGIN
   DBMS_OUTLN_EDIT.refresh_private_outline ('ORIGINAL_OLN');
   DBMS_OUTLN_EDIT.refresh_private_outline ('HINTED_OLN');
END;
/

COMMIT ;
ALTER SESSION SET use_private_outlines=TRUE;
ALTER SYSTEM FLUSH SHARED_POOL;
SET autotrace on

SELECT MIN (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

CREATE OR REPLACE OUTLINE cust_yob_otln FROM PRIVATE original_oln FOR CATEGORY outlines2 ;
ALTER SESSION SET use_private_outlines=FALSE;
alter session   SET use_stored_outlines=outlines2; 
ALTER SYSTEM FLUSH SHARED_POOL;

SELECT MIN (cust_income_level)
  FROM customers c
 WHERE cust_year_of_birth > 1985;

EXIT;

