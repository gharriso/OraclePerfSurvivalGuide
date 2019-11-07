/* Formatted on 2008/11/22 08:59 (Formatter Plus v4.8.7) */
CREATE TABLE customers AS SELECT * FROM sh.customers;

BEGIN
   FOR i IN 1 .. 2
   LOOP
      INSERT INTO customers
         SELECT c.cust_id,
                   c.cust_first_name
                || ' '
                || CHR (DBMS_RANDOM.VALUE (65, 91)) cust_first_name,
                c.cust_last_name, c.cust_gender, c.cust_year_of_birth,
                c.cust_marital_status, c.cust_street_address,
                c.cust_postal_code, c.cust_city, c.cust_city_id,
                c.cust_state_province, c.cust_state_province_id,
                c.country_id, c.cust_main_phone_number, c.cust_income_level,
                c.cust_credit_limit, c.cust_email, c.cust_total,
                c.cust_total_id, c.cust_src_id, c.cust_eff_from,
                c.cust_eff_to, c.cust_valid
           FROM customers c;

      COMMIT;
   END LOOP;
END;
/

CREATE INDEX customers_name_dob_i ON customers(cust_last_name,cust_first_name,cust_year_of_birth);

BEGIN
   FOR r IN (SELECT   *
                 FROM sh.customers
             ORDER BY cust_last_name, cust_first_name, cust_year_of_birth)
   LOOP
      NULL;
   END LOOP;
END;
/
