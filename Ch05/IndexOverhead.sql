/* Formatted on 2008/08/21 21:30 (Formatter Plus v4.8.7) */
ALTER SESSION SET tracefile_identifier=indexOverhead;

SET pages 1000
SET lines 160
SET echo on
SET timing on
rem possible bug workaround. 


SPOOL indexOverhead
REM
REM object creation here
REM
 
DROP TABLE customers_inx_test;


 
CREATE TABLE customers_inx_test AS
 SELECT * FROM sh.customers;

create index c1 on customers_inx_test (cust_id); 
create index c2 on customers_inx_test (cust_first_name); 
create index c3 on customers_inx_test (cust_last_name); 
create index c4 on customers_inx_test (cust_gender); 
create index c5 on customers_inx_test (cust_year_of_birth); 
create index c6 on customers_inx_test (cust_marital_status); 
create index c7 on customers_inx_test (cust_street_address); 

begin
    for i in 7..1 loop 
        execute immediate 'delete /* '||i||' indexes */ from customers_inx_test where cust_id < 1000' ; 
        rollback;
        execute immediate 'drop index c'||i||' on customers_inx_test';
    end loop; 
end; 
/
 

BEGIN
   DBMS_SESSION.session_trace_enable (waits => TRUE, binds => FALSE
                                                                   --,plan_stat      => 'all_executions'
   );
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (ownname      => USER,
                                  tabname      => 'CUSTOMERS_INX_TEST');

END;
/

SET autotrace on
REM
REM Queries, etc, here
REM
/* Formatted on 2008/08/23 12:48 (Formatter Plus v4.8.7) */
/* Formatted on 2008/08/23 12:51 (Formatter Plus v4.8.7) */
/* Formatted on 2008/08/23 12:53 (Formatter Plus v4.8.7) */
DECLARE
   i      INT             := 7;
   vsql   VARCHAR2 (2000);
BEGIN
   WHILE (i > 0)
   LOOP
      vsql :=
            'delete /* OPSG '
         || i
         || ' indexes */ from customers_inx_test where cust_id < 1000';
      DBMS_OUTPUT.put_line (vsql);

      EXECUTE IMMEDIATE vsql;

      ROLLBACK;
      vsql := 'drop index c' || i ;
      DBMS_OUTPUT.put_line (vsql);

      EXECUTE IMMEDIATE vsql;

      i := i - 1;
   END LOOP;
END;
/


/* Formatted on 2008/08/22 09:16 (Formatter Plus v4.8.7) */
  
SET autotrace off
SELECT tracefile
  FROM v$session s JOIN v$process p ON (p.addr = s.paddr)
 WHERE audsid = USERENV ('SESSIONID');

EXIT;

