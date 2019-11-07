var v_cust_id number;
var v_country_id number;

BEGIN
   :v_cust_id := &1;
   :v_country_id := 0;
END;
/

UPDATE customers
SET country_id = :v_country_id
WHERE cust_id = :v_cust_id;

