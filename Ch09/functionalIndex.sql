/* Formatted on 2008/10/12 15:18 (Formatter Plus v4.8.7) */
SET timing on
SET echo on
SET lines 120
SET pages 10000
SPOOL FunctionalIndex

DROP TABLE customers_fi;

CREATE TABLE customers_fi AS SELECT * FROM sh.customers;

CREATE INDEX  customers_fi_i1 ON customers_fi(cust_last_name, cust_first_name);

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_FI');
END;
/

VAR cust_first_name varchar2(40);
VAR cust_last_name varchar2(40);


BEGIN
   :cust_first_name := 'Lauren';
   :cust_last_name := 'Fenton';
END;
/

SET autotrace on

SELECT cust_id, cust_main_phone_number
  FROM customers_fi
 WHERE cust_last_name = :cust_last_name AND cust_first_name = :cust_first_name;
/
SELECT cust_id, cust_main_phone_number
  FROM customers_fi
 WHERE UPPER (cust_last_name) = UPPER (:cust_last_name)
   AND UPPER (cust_first_name) = UPPER (:cust_first_name);
/
CREATE INDEX customers_fi_funcidx_1 ON customers_fi(UPPER(cust_last_name),UPPER(cust_first_name));

SELECT cust_id, cust_main_phone_number
  FROM customers_fi
 WHERE UPPER (cust_last_name) = UPPER (:cust_last_name)
   AND UPPER (cust_first_name) = UPPER (:cust_first_name);
/

CREATE OR REPLACE FUNCTION f_generation (p_yob NUMBER)
   RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN (CASE
              WHEN p_yob < 1950
                 THEN 'Depression Era'
              WHEN p_yob < 1965
                 THEN 'Baby Boomer'
              WHEN p_yob < 1990
                 THEN 'Generation X'
              ELSE 'Generation Y'
           END
          );
END;
/

CREATE INDEX customers_funcidx2 ON customers_fi(f_generation(cust_year_of_birth));

SELECT AVG (cust_credit_limit), count(*) 
  FROM customers_fi
 WHERE f_generation (cust_year_of_birth) = 'Generation X';
 
 SELECT AVG (cust_credit_limit), count(*) 
  FROM customers_fi
 WHERE  cust_year_of_birth  = 1970;
 
 BEGIN
   DBMS_STATS.gather_table_stats
      (ownname         => user,
       tabname         => 'CUSTOMERS_FI',
       method_opt      => 'FOR ALL COLUMNS '||
       ' FOR COLUMNS (f_generation(cust_year_of_birth))'
      );
END;
/


SELECT AVG (cust_credit_limit), count(*) 
  FROM customers_fi
 WHERE f_generation (cust_year_of_birth) = 'Generation X'; 
 

EXIT;

