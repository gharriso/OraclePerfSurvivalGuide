set echo on 

SELECT *
FROM customers
WHERE cust_id = 49671
FOR  UPDATE WAIT 5;

SELECT *
FROM customers
WHERE cust_id = 49671
FOR  UPDATE NOWAIT ;



