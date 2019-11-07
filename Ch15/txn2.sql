UPDATE customers
   SET cust_valid = 'Y'
 WHERE cust_id = 100667;

UPDATE sales
   SET channel_id = 2
 WHERE cust_id = 100667;
