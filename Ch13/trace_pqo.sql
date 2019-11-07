BEGIN
   DBMS_SESSION.set_identifier ('gh pqo test 27');
END;
/
BEGIN
   DBMS_MONITOR.client_id_trace_enable (client_id => 'gh pqo test 27');
END;
/
SELECT /*+ parallel */ prod_name, SUM (amount_sold)
  FROM   products JOIN sales
  USING (prod_id)
GROUP BY   prod_name
ORDER BY   2 DESC;
/* Formatted on 30/12/2008 11:31:28 AM (QP5 v5.120.811.25008) */
