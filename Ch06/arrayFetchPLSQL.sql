/* Formatted on 2008/08/25 22:55 (Formatter Plus v4.8.7) */
DECLARE
   TYPE cust_id_type IS TABLE OF sh.customers.cust_id%TYPE
      INDEX BY BINARY_INTEGER;

   TYPE cust_last_name_type IS TABLE OF sh.customers.cust_last_name%TYPE
      INDEX BY BINARY_INTEGER;

   cust_id_list     cust_id_type;
   cust_name_list   cust_last_name_type;
BEGIN
   SELECT cust_id, cust_last_name
   BULK COLLECT INTO cust_id_list, cust_name_list
     FROM sh.customers;
END;

