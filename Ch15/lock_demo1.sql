/* Formatted on 2008/01/13 00:29 (Formatter Plus v4.8.7) */
SET termout off

CREATE TABLE opsg_customers
 (ID NUMBER PRIMARY KEY,
  customer_name VARCHAR2(2000),
  customer_address VARCHAR2(2000),
  status VARCHAR(1));

INSERT INTO opsg_customers
     VALUES (1, 'Acme Widgets', '2000 Mayfair Ave, AcmeVille,CA', 'A');

INSERT INTO opsg_customers
     VALUES (2, 'Fred''s Widgets', '1000 Fred Rd, FredVille, CA', 'A');
     
INSERT INTO opsg_customers
     VALUES (3, 'Janet''s Widgets', '1000 Janet Rd, JanetVille, CA', 'A');
     
commit; 
     
exit

