  SELECT *
     FROM customers
     WHERE cust_id = 49671
     FOR  UPDATE WAIT 2; 

