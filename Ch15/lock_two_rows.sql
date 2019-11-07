select cust_id from customers where cust_id=&1 for update wait 500; 
select cust_id from customers where cust_id=&2 for update wait 500; 
