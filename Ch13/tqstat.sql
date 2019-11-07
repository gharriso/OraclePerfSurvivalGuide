set pagesize 1000
set lines 120 
set echo on 
spool tqstat

set autotrace on 

SELECT /*+ parallel */ prod_name, SUM (amount_sold)
  FROM   products JOIN sales
  USING (prod_id)
GROUP BY   prod_name
ORDER BY   2 DESC;

set autotrace off

begin 
    dbms_lock.sleep(2); 
end; 
explain plan for 
SELECT /*+ parallel */ prod_name, SUM (amount_sold)
  FROM   products JOIN sales
  USING (prod_id)
GROUP BY   prod_name
ORDER BY   2 DESC;
select * from table(dbms_xplan.display(format=>'basic')); 

select dfo_number,tq_id,server_Type,min(num_rows),max(num_rows)  from v$pq_tqstat 
 group by dfo_number,tq_id,server_Type
 order by dfo_number, tq_id, server_type desc ;  
 
exit; 

