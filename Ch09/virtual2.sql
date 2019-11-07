DROP TABLE customers_fi;
set pagesize 10000
set lines 100

CREATE TABLE customers_fi AS
    SELECT * FROM sh.customers;

CREATE OR REPLACE FUNCTION f_generation(p_yob NUMBER)
    RETURN VARCHAR2
    DETERMINISTIC IS
BEGIN
    RETURN (CASE
                WHEN p_yob < 1950 THEN 'Pre-boomer'
                WHEN p_yob < 1965 THEN 'Baby Boomer'
                WHEN p_yob < 1990 THEN 'Generation X'
                ELSE 'Generation Y'
            END);
END;
/

set echo on 

ALTER TABLE customers_fi ADD cust_generation GENERATED
      ALWAYS AS (f_generation (cust_year_of_birth) );

BEGIN
    sys.DBMS_STATS.gather_table_stats(ownname => USER,
    tabname => 'CUSTOMERS_FI');
END;
/

set autotrace on


SELECT AVG(cust_credit_limit), COUNT( * )
FROM customers_fi
WHERE cust_generation = 'Generation X';
