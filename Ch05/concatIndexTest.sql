/* Formatted on 2008/08/19 18:53 (Formatter Plus v4.8.7) */
alter session set sql_trace true; 
alter session set tracefile_identifier=concat_test; 
DROP TABLE customers1;
CREATE TABLE customers1 AS SELECT * FROM sh.customers;
CREATE INDEX cust_i_last ON customers1(cust_last_name);
CREATE INDEX cust_i_last_first ON customers1(cust_last_name,cust_first_name);
CREATE INDEX cust_i_last_first_year ON customers1(cust_last_name,cust_first_name,cust_year_of_birth);
CREATE INDEX cust_i_last_first_year_id ON customers1(cust_last_name,cust_first_name,cust_year_of_birth,cust_id);
create index cust_i_first_year on customers1(cust_first_name, cust_year_of_birth); 
create index cust_i_first on customers1(cust_first_name); 
create index cust_i_last on customers1(cust_last_name); 
create index cust_i_year on customers1(cust_year_of_birth); 
begin 
    dbms_stats.gather_table_stats(ownname=>user,tabname=>'CUSTOMERS1');
end;
/
 SELECT /*+ full(c) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;   
SELECT /*+ index(c,cust_i_last) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;
SELECT /*+ index(c,cust_i_last_first) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;
SELECT /*+ index(c,cust_i_last_first_year) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;
SELECT /*+ index(c,cust_i_last_first_year_id) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;
   
SELECT /*+ and_equal(c,cust_i_last,cust_i_first,cust_i_year) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_last_name = 'Bishop'
   AND cust_year_of_birth = 1976;
SELECT /*+ full(c) */
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_year_of_birth = 1976;
SELECT /*+ index_ss(c,cust_i_last_first_year)*/
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_year_of_birth = 1976;
SELECT /*+ index(c,cust_i_first_year)*/
       cust_id
  FROM customers1 c
 WHERE cust_first_name = 'Connor'
   AND cust_year_of_birth = 1976;


exit; 
