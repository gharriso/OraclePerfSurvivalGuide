-- Start of DDL Script for View OPSG.OPSG_DELTA_REPORT
-- Generated 11/08/2008 4:41:03 PM from OPSG@GH10GD

CREATE OR REPLACE VIEW opsg_delta_report (
   start_timestamp,
   end_timestamp,
   sample_seconds,
   stat_name,
   total_waits,
   time_waited_micro,
   waits_per_second,
   microseconds_per_second,
   pct_of_time )
AS
SELECT  start_timestamp,end_timestamp, ROUND( (end_timestamp - start_timestamp) * 24 * 3600) sample_seconds,
         stat_name, total_waits, time_waited_micro,
         ROUND (waits_per_second, 4) waits_per_second,
         ROUND (microseconds_per_second, 4) microseconds_per_second,
         round(microseconds_per_second*100/sum(microseconds_per_second) over(),2) as pct_of_time
    FROM TABLE (opsg_pkg.wait_time_report ())
ORDER BY microseconds_per_second DESC
/


-- End of DDL Script for View OPSG.OPSG_DELTA_REPORT

