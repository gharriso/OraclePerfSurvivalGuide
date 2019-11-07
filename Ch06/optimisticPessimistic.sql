/* Formatted on 2008/08/29 16:32 (Formatter Plus v4.8.7) */
CREATE TABLE customers_rd ROWDEPENDENCIES AS
 SELECT * FROM sh.customers;
ALTER  TABLE customers_rd ADD PRIMARY KEY(cust_id);


CREATE OR REPLACE PROCEDURE credit_check (p_cust_id NUMBER)
IS
BEGIN
   SYS.DBMS_LOCK.sleep (30);
END;
/

CREATE OR REPLACE PROCEDURE optimistic_trans (
   p_cust_id      NUMBER,
   p_add_credit   NUMBER
)
IS
   v_start_rowscn   NUMBER;
BEGIN
   SELECT ORA_ROWSCN            -- Get the start SCN
     INTO v_start_rowscn
     FROM customers_rd
    WHERE cust_id = p_cust_id;

   credit_check (p_cust_id);    -- Time consuming credit check 

   UPDATE customers_rd
      SET cust_credit_limit = cust_credit_limit + p_add_credit
    WHERE cust_id = p_cust_id AND ORA_ROWSCN = v_start_rowscn;

   IF SQL%ROWCOUNT = 0
   THEN                         -- SCN must have changed
      ROLLBACK;
      raise_application_error (-20001,
                               'Optimistic transaction failed - please retry'
                              );
   ELSE
      COMMIT;
   END IF;
END;
/

PROCEDURE PESIMISTIC_TRANS (p_cust_id NUMBER, p_add_credit NUMBER)
IS
   v_cust_id   NUMBER;
BEGIN
   SELECT     cust_id
         INTO v_cust_id                                        -- Lock the row
         FROM customers_rd
        WHERE cust_id = p_cust_id
   FOR UPDATE;

   credit_check (p_cust_id);                    -- Time consuming credit check

   UPDATE customers_rd
      SET cust_credit_limit = cust_credit_limit + p_add_credit
    WHERE cust_id = p_cust_id;

   COMMIT;
END;
/

