/* Formatted on 2008/10/20 19:37 (Formatter Plus v4.8.7) */
SPOOL rangeScan


SET lines 120
SET pages 10000
SET echo on

ALTER SESSION SET tracefile_identifier=rangescan;

ALTER SESSION SET sql_trace= TRUE;

CREATE INDEX salesregion_i1 ON salesregion (lowphoneno, highphoneno);
create index salesregion_hilow on salesregion ( highphoneno,lowphoneno);

BEGIN
   DBMS_STATS.gather_table_stats (ownname => USER, tabname => 'SALESREGION');
END;
/

SET autotrace on

SELECT *
  FROM salesregion
 WHERE '500000015' BETWEEN lowphoneno AND highphoneno;

SELECT /*+FIRST_ROWS*/
       *
  FROM salesregion
 WHERE '500000015' BETWEEN lowphoneno AND highphoneno;

SELECT *
  FROM salesregion
 WHERE '500000015' BETWEEN lowphoneno AND highphoneno AND ROWNUM = 1;

CREATE OR REPLACE FUNCTION region_lookup (p_phone_no VARCHAR2)
   RETURN VARCHAR2
IS
   CURSOR salesregion_csr (cp_phone_no VARCHAR2)
   IS
      SELECT  /*+ INDEX(S) */ regionname,lowphoneno
          FROM salesregion s
      WHERE cp_phone_no < highphoneno
      ORDER BY highphoneno;

   salesregion_row   salesregion_csr%ROWTYPE;
    v_return_value salesregion.regionname%type;
BEGIN
   OPEN salesregion_csr (p_phone_no);

   FETCH salesregion_csr
    INTO salesregion_row;

   IF salesregion_csr%NOTFOUND
   THEN
      -- No match found;
      NULL;
   ELSIF salesregion_row.lowphoneno > p_phone_no
   THEN
      -- Still no match
      NULL;
   ELSE
      -- The row in salesregion_row is the matching row
      v_return_value := salesregion_row.regionname;
   END IF;

   CLOSE salesregion_csr;

   RETURN (v_return_value);
END;
/
select region_lookup ('500000015') from dual; 
EXIT;

