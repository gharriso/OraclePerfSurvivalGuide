SPOOL compress
SET echo on
SET lines 120
SET pages 10000
SET timing on
DROP TABLE sales;
DROP TABLE sales_nc;
DROP TABLE sales_c_dss;
DROP TABLE sales_c_oltp;
 DROP TABLE sales_c_a1;
  DROP TABLE sales_c_a2;
   DROP TABLE sales_c_a3;

CREATE TABLE sales AS
   SELECT /*+ cache(s) */
          *
   FROM sh.sales s;

CREATE TABLE sales_nc
NOCOMPRESS AS
   SELECT /*+ cache(s) */
          *
   FROM sh.sales s;

CREATE TABLE sales_c_dss
COMPRESS FOR DIRECT_LOAD OPERATIONS AS
   SELECT /*+ cache(s) */
          *
   FROM sh.sales s;

CREATE TABLE sales_c_oltp
COMPRESS FOR ALL OPERATIONS AS
   SELECT /*+ cache(s) */
          *
   FROM sh.sales s;
create table sales_c_a1 compress for archive level=1 as select
      /*+ cache(s) */  *
      from sh.sales s;

create table sales_c_a2 compress for archive level=2 as select
      /*+ cache(s) */  *
      from sh.sales s;

create table sales_c_a3 compress for archive level=3 as select
      /*+ cache(s) */  *
      from sh.sales s;

BEGIN
   sys.DBMS_STATS.gather_schema_stats(ownname => USER);
END;
/

SELECT table_name, compress_for, blocks
FROM user_tables
WHERE table_name LIKE 'SALES_%';
/* Formatted on 12-Jan-2009 12:02:21 (QP5 v5.120.811.25008) */
