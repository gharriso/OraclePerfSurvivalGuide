var v_cust_id number;
var v_qs number;

BEGIN
   :v_cust_id := 100667;
   :v_qs  := 0;
END;
/

UPDATE sales 
SET quantity_sold=:v_qs
WHERE cust_id = :v_cust_id;

