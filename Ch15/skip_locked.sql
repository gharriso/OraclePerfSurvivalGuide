rollback; 

update customers set cust_valid='X'
 where mod(cust_id,9000)=round(dbms_random.value(1,9999)); 
 
SELECT COUNT( * )
FROM customers
WHERE cust_valid = 'X';

SELECT cust_id 
FROM customers
WHERE cust_valid = 'X'
FOR UPDATE SKIP LOCKED; 
/* Formatted on 5-Feb-2009 22:15:35 (QP5 v5.120.811.25008) */
