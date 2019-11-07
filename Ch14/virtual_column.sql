set echo on
set timing on
DROP TABLE sales;

CREATE TABLE sales AS
    SELECT *
    FROM sh.sales
    WHERE ROWNUM < 1;

ALTER SYSTEM FLUSH BUFFER_CACHE;
TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales;

TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales /*+ baseline  */;

ALTER TABLE sales  DROP COLUMN unit_price;
ALTER TABLE sales  ADD unit_price GENERATED ALWAYS AS (
      CASE WHEN quantity_sold > 0 THEN
           ROUND(amount_sold/quantity_sold,2)
      END );
ALTER SYSTEM FLUSH BUFFER_CACHE;
TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales;

TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales /*+ virtual column  */;

ALTER TABLE sales  DROP COLUMN unit_price;
ALTER TABLE sales ADD unit_price number;

CREATE TRIGGER sales_iu_trg
    BEFORE INSERT OR UPDATE
    ON sales
    FOR EACH ROW
    WHEN(new.quantity_sold > 0)
BEGIN
    :new.unit_price := :new.amount_sold / :new.quantity_sold;
END;
/


UPDATE sales
SET quantity_sold = quantity_sold;

ALTER SYSTEM FLUSH BUFFER_CACHE;
TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales;

TRUNCATE TABLE sales;

INSERT INTO sales(prod_id, cust_id, time_id, channel_id, promo_id,
                  quantity_sold, amount_sold)
    SELECT * FROM sh.sales /*+ trigger */;
