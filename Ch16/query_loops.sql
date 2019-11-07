@@latch_delta_qry

begin 
  query_loops ( run_seconds=>&1 , hi_val =>&2 , 
                   use_binds =>&3, reset_cache =>&4 ,reset_pool=>&4 ,
                   round_lookups=>&5,range_query=>&6); 
end;
/

@@latch_delta_qry

exit;


 
