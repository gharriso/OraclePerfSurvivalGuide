DECLARE
   v_amt   NUMBER;
BEGIN
   FOR r IN (SELECT cust_id
             FROM sh.customers
             WHERE ROWNUM < 100) LOOP
      EXECUTE IMMEDIATE 'select sum(amount_sold)  from sh.sales where cust_id='
                       || r.cust_id
         INTO v_amt;
   END LOOP;
END;
/

/* Formatted on 13/01/2009 10:31:54 AM (QP5 v5.120.811.25008) */
