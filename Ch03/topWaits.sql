rem *********************************************************** 
rem
rem	File: topWaits.sql 
rem	Description: Non-idle wait times sorted by time waited
rem   
rem	From 'Oracle Performance Survival Guide' by Guy Harrison
rem		Chapter 3 Page 70
rem		ISBN: 978-0137011957
rem		See www.guyharrison.net for further information
rem  
rem		This work is in the public domain NSA 
rem   
rem
rem ********************************************************* 


/* Formatted on 2008/08/15 13:37 (Formatter Plus v4.8.7) */
SET lines 100
SET pages 10000
COLUMN wait_class format a12
COLUMN event format a30
COLUMN total_waits format 999999
COLUMN total_us format 999999999
COLUMN pct_time format 99.99
COLUMN avg_us format 999999.99
SET echo on

SELECT   wait_class, event, total_waits AS waits,
         ROUND (time_waited_micro / 1000) AS total_ms,
         ROUND (time_waited_micro * 100 / SUM (time_waited_micro) OVER (),
                2
               ) AS pct_time,
         ROUND ((time_waited_micro / total_waits) / 1000, 2) AS avg_ms
    FROM v$system_event
   WHERE wait_class <> 'Idle'
ORDER BY time_waited_micro DESC;

