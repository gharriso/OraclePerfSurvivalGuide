DROP TABLE sales;
DROP TABLE products;

CREATE TABLE sales AS
    SELECT * FROM sh.sales;

CREATE TABLE products AS
    SELECT * FROM sh.products;

BEGIN
    dbms_stats.gather_table_stats(
    sys.DBMS_STATS.gather_table_stats(ownname => USER,
    tabname => 'SALES');
    sys.DBMS_STATS.gather_table_stats(ownname => USER,
    tabname => 'PRODUCTS');
END;
/

ALTER SESSION SET tracefile_identifier=pivot;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';

set timing on
set autotrace on
set echo on

alter system flush buffer_cache; 

SELECT /* Pivot */ * FROM (
    SELECT p.prod_name, TO_CHAR(s.time_id, 'YYYY') year,
           s.quantity_sold
    FROM     sales s
         JOIN
             products p
         USING (prod_id))
  PIVOT(SUM(quantity_sold) FOR year IN
        ('1999','2000','2001','2002','2003','2004',
         '2005','2006','2007','2008','2009'));

alter system flush buffer_cache; 
                  

SELECT /* Decode */ prod_name,
       SUM(DECODE(year, '1999', quantity_sold, NULL)) "1999",
       SUM(DECODE(year, '2000', quantity_sold, NULL)) "2000",
       SUM(DECODE(year, '2001', quantity_sold, NULL)) "2001",
       SUM(DECODE(year, '2002', quantity_sold, NULL)) "2002",
       SUM(DECODE(year, '2003', quantity_sold, NULL)) "2003",
       SUM(DECODE(year, '2004', quantity_sold, NULL)) "2004",
       SUM(DECODE(year, '2005', quantity_sold, NULL)) "2005",
       SUM(DECODE(year, '2006', quantity_sold, NULL)) "2006",
       SUM(DECODE(year, '2007', quantity_sold, NULL)) "2007",
       SUM(DECODE(year, '2008', quantity_sold, NULL)) "2008",
       SUM(DECODE(year, '2009', quantity_sold, NULL)) "2009"
 FROM (SELECT p.prod_name, TO_CHAR(s.time_id, 'YYYY') year,
              s.quantity_sold
         FROM sales s JOIN products p
              USING (prod_id))
GROUP BY prod_name;

alter system flush buffer_cache; 

SELECT /* CASE */ prod_name,
       SUM(CASE year WHEN '1999' THEN quantity_sold END) "1999",
       SUM(CASE year WHEN '2000' THEN quantity_sold END) "2000",
       SUM(CASE year WHEN '2001' THEN quantity_sold END) "2001",
       SUM(CASE year WHEN '2002' THEN quantity_sold END) "2002",
       SUM(CASE year WHEN '2003' THEN quantity_sold END) "2003",
       SUM(CASE year WHEN '2004' THEN quantity_sold END) "2004",
       SUM(CASE year WHEN '2005' THEN quantity_sold END) "2005",
       SUM(CASE year WHEN '2006' THEN quantity_sold END) "2006",
       SUM(CASE year WHEN '2007' THEN quantity_sold END) "2007",
       SUM(CASE year WHEN '2008' THEN quantity_sold END) "2008",
       SUM(CASE year WHEN '2009' THEN quantity_sold END) "2009"
FROM (SELECT p.prod_name, TO_CHAR(s.time_id, 'YYYY') year,
             s.quantity_sold
      FROM     sales s
           JOIN
               products p
           USING (prod_id))
GROUP BY prod_name;


