set pages 1000
set lines 100

EXPLAIN PLAN FOR 
INSERT /*+ append */
                  INTO SALES(PROD_ID, CUST_ID, TIME_ID,
                             CHANNEL_ID, PROMO_ID,
                             QUANTITY_SOLD, AMOUNT_SOLD)
            VALUES (:1, :2, :3,:4,:5,:6,:7 );
            
select * from table(dbms_xplan.display()); 

EXPLAIN PLAN FOR 
INSERT /*+ append */
                  INTO SALES(PROD_ID, CUST_ID, TIME_ID,
                             CHANNEL_ID, PROMO_ID,
                             QUANTITY_SOLD, AMOUNT_SOLD)
  select * from sales_updates; 
  
select * from table(dbms_xplan.display()); 


            

