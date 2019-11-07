alter table sales no flashback archive;
DROP TABLE sales;
DROP TABLE sales_updates;

CREATE TABLE sales AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 1;

ALTER TABLE sales FLASHBACK ARCHIVE;

CREATE TABLE sales_updates AS
   SELECT *
   FROM sh.sales
   WHERE ROWNUM < 100000;

ALTER SESSION SET tracefile_identifier=sales_fba;

BEGIN
   DBMS_SESSION.session_trace_enable(waits => TRUE, binds => FALSE);

   FOR r IN (SELECT sid, serial#
             FROM v$session
             WHERE program LIKE '%FBDA%') LOOP
      sys.DBMS_MONITOR.session_trace_enable(session_id => R.SID,
      serial_num => R.serial#, waits => TRUE, binds => FALSE);
   END LOOP;
END;
/

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id, quantity_sold, amount_sold)
   SELECT prod_id, cust_id, time_id, channel_id, promo_id, quantity_sold,
          amount_sold
   FROM sales_updates;

COMMIT;
alter system flush buffer_cache;

/* Formatted on 5-Feb-2009 12:13:37 (QP5 v5.120.811.25008) */
