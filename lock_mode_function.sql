CREATE OR REPLACE FUNCTION lock_mode(lmode NUMBER)
   RETURN VARCHAR2 IS
   smode   VARCHAR2(30);
BEGIN
   smode :=
      CASE lmode
         WHEN 0 THEN 'none'
         WHEN 1 THEN 'Null'
         WHEN 2 THEN 'Row-Share (RS)'
         WHEN 3 THEN 'Row-Exclusive (RX)'
         WHEN 4 THEN 'Share (S)'
         WHEN 5 THEN 'Share Row-Exclusive (SRX)'
         WHEN 6 THEN 'Exclusive (X)'
      END;
   RETURN (smode);
END;
/

/* Formatted on 24/01/2009 12:38:45 PM (QP5 v5.120.811.25008) */
