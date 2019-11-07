-- Start of DDL Script for Package OPSG.SP_NET_TEST
-- Generated 1-Dec-2008 22:03:15 from OPSG@gh10gd

CREATE OR REPLACE 
PACKAGE sp_net_test
  IS


  FUNCTION calc_discount (p_cust_id NUMBER)
      RETURN NUMBER;
END; -- Package spec
/
create or replace
PACKAGE BODY SP_NET_TEST
IS
   FUNCTION discountcalc (a NUMBER, b NUMBER, c NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      RETURN (a + b + c);
   END;

   FUNCTION calc_discount (p_cust_id NUMBER)
      RETURN NUMBER
   IS
      CURSOR cust_csr
      IS
         SELECT quantity_sold, amount_sold, prod_id
           FROM sh.sales
          WHERE cust_id = p_cust_id;

      v_total_discount   NUMBER := 0;
   BEGIN
      FOR cust_row IN cust_csr
      LOOP
         v_total_discount :=
              v_total_discount
            + discountcalc (cust_row.quantity_sold,
                            cust_row.prod_id,
                            cust_row.amount_sold
                           );
      END LOOP;
      RETURN(v_total_discount ); 
   END;
END;
/

-- End of DDL Script for Package OPSG.SP_NET_TEST

