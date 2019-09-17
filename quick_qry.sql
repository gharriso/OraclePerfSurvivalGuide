SELECT  --start_timestamp,end_timestamp, ROUND( (end_timestamp - start_timestamp) * 24 * 3600) sample_seconds,
         stat_name, 
         round(microseconds_per_second*100/sum(microseconds_per_second) over(),2) as pct_of_time
    FROM TABLE (opsg_pkg.wait_time_report ()) where microseconds_per_second >0
ORDER BY microseconds_per_second DESC
/
