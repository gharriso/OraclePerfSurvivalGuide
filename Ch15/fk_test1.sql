DROP TABLE sales;
DROP TABLE customers;

CREATE TABLE customers AS
   SELECT * FROM sh.customers;

CREATE TABLE sales AS
   SELECT * FROM sh.sales;

ALTER TABLE customers ADD CONSTRAINT cust_pk PRIMARY KEY (cust_id);
ALTER TABLE sales
ADD CONSTRAINT sales_cust_fk
FOREIGN KEY (cust_id)
REFERENCES customers (cust_id);



select * from v_my_locks; 


BEGIN
   LOOP
      update customers set cust_id=cust_id; 
      delete from customers where cust_id = 49671;
      ROLLBACK;
   END LOOP;
END;
/ 

