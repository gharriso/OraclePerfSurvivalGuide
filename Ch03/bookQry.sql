BEGIN
   DBMS_SESSION.session_trace_enable (waits          => TRUE,
                                      binds          => FALSE,
                                      plan_stat      => 'all_executions'
                                     );
END;
/

alter session set tracefile_identifier=transim; 
var book_id number; 
begin
    :book_id:=34316;
end;
    /
SELECT * FROM g_orders
  JOIN g_line_items USING (order_id)
  JOIN g_customers USING (customer_id) WHERE
           g_line_items.book_id=:book_id; 
           
select * from v$parameter where name='user_dump_dest';


