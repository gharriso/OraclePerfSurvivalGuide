
# Oracle Performance Survival Guide - Scripts

Here you can obtain the scripts and examples from [Oracle Performance Survival Guide](http://www.amazon.com/gp/product/0137011954?tag=guyharswebbit-20) by [Guy Harrison](http://www.guyharrison.net).  

An archive containing the full set of scripts can be downloaded [here](http://165.225.144.123/OPSGSamples/opsg.zip).  Individual files can be downloaded [below](#Listing_of_individual_utility_scripts).  

The archive contains both utility scriptsand all of the SQL files that I used to create various test loads while writing the book.  The utility scripts are described in the index.html file contained within the archive.  These scripts provide reports on various aspects of database health and performance.  

The rest of the SQL files are provided as is, and without descriptions.  You might find them useful if you are trying to replicate my workloads.  

Some of the scripts will only work if you install some packages, views and permissions.  In particular, the OPSG_PKG package provides an ability to generate short term delta and rate reports against the time model and wait interface.  See [installation](#installation), below, for instructions.  

I hope you find these scripts - and my book - useful.  If you have any problems please contact me at [guy.a.harrison@gmail.com](mailto:guy.a.harrison@gmail.com).    

Regards,  

[Guy Harrison](http://www.guyharrison.net)  

## <a name="installation"></a>Installation 

Many scripts can be run without any installation providing that the user has access to V$ views.  However, a few require specialized views and that the OPSG_PKG be installed.  To install the package:  

1\. Open a command prompt within the "install" directory  
2\. execute either install_opsg.bat (Windows) or install_opsg.sh (Linux/Unix)  
3\. Respond to the prompts  

Here is an example session:  

<div style="margin-left: 40px;">`C:\tmp\opsg\install>install_opsg`  

`C:\tmp\opsg\install>sqlplus /nolog @install_opsg`  

`SQL*Plus: Release 11.1.0.7.0 - Production on Thu Sep 10 10:55:02 2009`  

`Copyright (c) 1982, 2008, Oracle.  All rights reserved.`  

`Enter password for the (new) OPSG user:opsg`  
`Enter SYS password:`  
`Enter TNSNAMES entry:g11r2ga`  
</div>

The script creates a user OPSG which has privileges to run all of the scripts and which has appropriate permissions.  You can modify the script if you want to install a different user.   You do need the SYS password to install the user.  

### Extending the SH schema

I found the data volumes in Oracle's SH schema too low to illustrate some of the SQL tuning principles.  The script extend_sh_schema.sql in the scripts directory will add about 2 million rows to the SALES and COSTS tables.   These updates are applied directly to the SH schema.    

## <a name="Listing_of_individual_utility_scripts"></a>Listing of individual utility scripts

<table border="0">

<tbody>

<tr>

<td>**Chapter 3: Tools of the Trade**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 41</td>

<td>[topsql1.sql](http://guyh.textdriven.com/OPSGSamples/Ch03/topsql1.sql )</td>

<td>Top 10 cached sql statements by elapsed time</td>

</tr>

<tr>

<td>p 58</td>

<td>[loginTrigger.sql](http://guyh.textdriven.com/OPSGSamples/Ch03/loginTrigger.sql )</td>

<td>Example of a login trigger that activates SQL trace</td>

</tr>

<tr>

<td>p 70</td>

<td>[topWaits.sql](http://guyh.textdriven.com/OPSGSamples/Ch03/topWaits.sql )</td>

<td>Non-idle wait times sorted by time waited</td>

</tr>

<tr>

<td>p 73</td>

<td>[timeModelSimple.sql](http://guyh.textdriven.com/OPSGSamples/Ch03/timeModelSimple.sql )</td>

<td>Time model unioned with wait data to show waits combined with CPU timings</td>

</tr>

<tr>

<td>p 55</td>

<td>[CurrentSessionTraceStatus.sql](http://guyh.textdriven.com/OPSGSamples/Ch03/CurrentSessionTraceStatus.sql )</td>

<td>Show the full name and path of the trace file for the current session</td>

</tr>

<tr>

<td>**Chapter 5: Indexing and Clustering**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 122</td>

<td>[monitoringOn.sql](http://guyh.textdriven.com/OPSGSamples/Ch05/monitoringOn.sql )</td>

<td>Turn on monitoring for all indexes</td>

</tr>

<tr>

<td>p 122</td>

<td>[vobject.sql](http://guyh.textdriven.com/OPSGSamples/Ch05/vobject.sql )</td>

<td>Show usage statistics for indexes</td>

</tr>

<tr>

<td>p 133</td>

<td>[checkPlanCache.sql](http://guyh.textdriven.com/OPSGSamples/Ch05/checkPlanCache.sql )</td>

<td>Report on indexes that are not found in any cached execution plan</td>

</tr>

<tr>

<td>**Chapter 6: Application Design and Implementation**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 157</td>

<td>[force_matching.sql](http://guyh.textdriven.com/OPSGSamples/Ch06/force_matching.sql )</td>

<td>Identify SQLs that are identical other than for literal values (Force matching candidates)</td>

</tr>

<tr>

<td>**Chapter 7: Optimizing the Optimizer**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 194</td>

<td>[ses_optimizer.sql](http://guyh.textdriven.com/OPSGSamples/Ch07/ses_optimizer.sql )</td>

<td>Show optimizer parameters in effect for the curren session</td>

</tr>

<tr>

<td>p 198</td>

<td>[disableStats.sql](http://guyh.textdriven.com/OPSGSamples/Ch07/disableStats.sql)</td>

<td>Disable automatic statistics collection</td>

</tr>

<tr>

<td>**Chapter 11: Sorting Grouping and Set Operations**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 332</td>

<td>[sql_workarea.sql](http://guyh.textdriven.com/OPSGSamples/Ch11/sql_workarea.sql )</td>

<td>Show statistics onsort and hash workareas (from V$SQL_WORKAREA)</td>

</tr>

<tr>

<td>**Chapter 12: Using and Tuning PL/SQL**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 355</td>

<td>[plsqltime_sys.sql](http://guyh.textdriven.com/OPSGSamples/Ch12/plsqltime_sys.sql )</td>

<td>Query to reveal the overhead of PLSQL within the database</td>

</tr>

<tr>

<td>p 356</td>

<td>[cachedPlsql.sql](http://guyh.textdriven.com/OPSGSamples/Ch12/cachedPlsql.sql )</td>

<td>Show statements in the cache with PLSQL component and show pct of time spent in PLSQL</td>

</tr>

<tr>

<td>p 357</td>

<td>[queryProfiler.sql](http://guyh.textdriven.com/OPSGSamples/Ch12/queryProfiler.sql )</td>

<td>Report on data held in the PLSQL_PROFILER tables</td>

</tr>

<tr>

<td>p 360</td>

<td>[hrpof_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch12/hrpof_qry.sql )</td>

<td>Query agains the DBMSHP (hierarchical profiler) tables</td>

</tr>

<tr>

<td>**Chapter 13: Parallel SQL**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 414</td>

<td>[px_session.sql](http://guyh.textdriven.com/OPSGSamples/Ch13/px_session.sql )</td>

<td>Show real time view of current parallel executions</td>

</tr>

<tr>

<td>p 413</td>

<td>[tqstat2.sql](http://guyh.textdriven.com/OPSGSamples/Ch13/tqstat2.sql )</td>

<td>Example of using v$pq_tqstat to reveal PQO workload distribution</td>

</tr>

<tr>

<td>p 422</td>

<td>[rac_pqo2.sql](http://guyh.textdriven.com/OPSGSamples/Ch13/rac_pqo2.sql )</td>

<td>Example of using v$pq_tqstat to show inster-instance parallel in RAC</td>

</tr>

<tr>

<td>**Chapter 15: Lock Contention**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 460</td>

<td>[lock_type.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/lock_type.sql )</td>

<td>Show definition of all lock codes</td>

</tr>

<tr>

<td>p 461</td>

<td>[v_my_locks.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/v_my_locks.sql)</td>

<td>View definition that will show all locks held by the current user</td>

</tr>

<tr>

<td>p 467</td>

<td>[lock_delta_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/lock_delta_qry.sql )</td>

<td>Show lock waits compared to other waits and CPU over a short time period</td>

</tr>

<tr>

<td>p 466</td>

<td>[lock_wait_events.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/lock_wait_events.sql )</td>

<td>Show lock waits compared to other waits and CPU</td>

</tr>

<tr>

<td>p 468</td>

<td>[ash_locks.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/ash_locks.sql )</td>

<td>Show lock wait information from Active Session History (ASH)</td>

</tr>

<tr>

<td>p 468</td>

<td>[awr_locks.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/awr_locks.sql )</td>

<td>Show lock wait information from Active Workload Repository (AWR)</td>

</tr>

<tr>

<td>p 470</td>

<td>[locking_sql.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/locking_sql.sql )</td>

<td>Show SQLs with the highest lock waits</td>

</tr>

<tr>

<td>p 471</td>

<td>[segment_stats.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/segment_stats.sql )</td>

<td>Show segments with the highest lock waits</td>

</tr>

<tr>

<td>p 472</td>

<td>[application_module_wait.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/application_module_wait.sql )</td>

<td>Show SQLs for a particular module with lock waits</td>

</tr>

<tr>

<td>p 472</td>

<td>[session_lock_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/session_lock_waits.sql )</td>

<td>Show sessions with a specific USERNAME and their lock waits</td>

</tr>

<tr>

<td>p 476</td>

<td>[blockers.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/blockers.sql )</td>

<td>Simple blocking locks script</td>

</tr>

<tr>

<td>p 477</td>

<td>[lock_tree.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/lock_tree.sql )</td>

<td>Lock tree built up from V$SESSION</td>

</tr>

<tr>

<td>p 477</td>

<td>[show_session_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/show_session_waits.sql )</td>

<td>Blocking row level locks at the session level</td>

</tr>

<tr>

<td>p 478</td>

<td>[wait_chains.sql](http://guyh.textdriven.com/OPSGSamples/Ch15/wait_chains.sql )</td>

<td>Lock tree built up from V$wait_chains</td>

</tr>

<tr>

<td>**Chapter 16: Latch and Mutex contention**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 494</td>

<td>[latch_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latch_waits.sql )</td>

<td>Latch/mutex waits compared to other non-idle waits and to CPU</td>

</tr>

<tr>

<td>p 496</td>

<td>[latch_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latch_qry.sql )</td>

<td>"Latch statistics - gets</td>

</tr>

<tr>

<td>p 497</td>

<td>[ash_latch.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/ash_latch.sql )</td>

<td>Latch statistics from Active Session History (ASH)</td>

</tr>

<tr>

<td>p 495</td>

<td>[latch_delta_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latch_delta_qry.sql )</td>

<td>Latch/mutex waits over a short duration compared to other waits</td>

</tr>

<tr>

<td>p 497</td>

<td>[latching_sql.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latching_sql.sql )</td>

<td>SQLs with the highest concurrency waits (possible latch/mutex-related)</td>

</tr>

<tr>

<td>p 500</td>

<td>[force_matching.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/force_matching.sql )</td>

<td>SQLs not using bind variables - possibly causing library cache mutex contention</td>

</tr>

<tr>

<td>p 499</td>

<td>[libcache.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/libcache.sql )</td>

<td>Library cache statistics</td>

</tr>

<tr>

<td>p 503</td>

<td>[cbc_config.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/cbc_config.sql )</td>

<td>"Number of Cache Buffers Chains latches & number of buffers covered</td>

</tr>

<tr>

<td>p 504</td>

<td>[cbc_blocks.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/cbc_blocks.sql )</td>

<td>Blocks with the highest touch counts and latches involved</td>

</tr>

<tr>

<td>p 505</td>

<td>[rowcache_latches.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/rowcache_latches.sql )</td>

<td>Rowcache latch statistics</td>

</tr>

<tr>

<td>p 510</td>

<td>[latch_class.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latch_class.sql )</td>

<td>Adjusting spin count for an individual latch class</td>

</tr>

<tr>

<td>p 511</td>

<td>[latch_class_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch16/latch_class_qry.sql )</td>

<td>Query to show latch class configuration</td>

</tr>

<tr>

<td>**Chapter 17: Shared Memory Contention**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 519</td>

<td>[iostat_file.sql](http://guyh.textdriven.com/OPSGSamples/Ch17/iostat_file.sql )</td>

<td>Status of ansynchronous IO</td>

</tr>

<tr>

<td>p 521</td>

<td>[flash_size.sql](http://guyh.textdriven.com/OPSGSamples/Ch17/flash_size.sql )</td>

<td>Size of the flashback log buffer</td>

</tr>

<tr>

<td>p 526</td>

<td>[waitstat.sql](http://guyh.textdriven.com/OPSGSamples/Ch17/waitstat.sql )</td>

<td>Buffer busy waits by buffer type</td>

</tr>

<tr>

<td>p 526</td>

<td>[busy_segments.sql](http://guyh.textdriven.com/OPSGSamples/Ch17/busy_segments.sql )</td>

<td>Buffer busy waits by segment</td>

</tr>

<tr>

<td>**Chapter 18: Buffer Cache Tuning**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 538</td>

<td>[temporary_direct.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/temporary_direct.sql )</td>

<td>Direct path IO and buffered IO</td>

</tr>

<tr>

<td>p 540</td>

<td>[buffer_pool_objects.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/buffer_pool_objects.sql )</td>

<td>Segments cached in the buffer pools</td>

</tr>

<tr>

<td>p 541</td>

<td>[hit_rate.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/hit_rate.sql )</td>

<td>"""hit rates"" for direct and cached IOs "</td>

</tr>

<tr>

<td>p 542</td>

<td>[hit_rate_delta.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/hit_rate_delta.sql )</td>

<td>"""hit rates"" calculated over a time interval "</td>

</tr>

<tr>

<td>p 544</td>

<td>[sql_miss_rates.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/sql_miss_rates.sql )</td>

<td>logical and physical IO for specific SQLs</td>

</tr>

<tr>

<td>p 546</td>

<td>[buffer_pool_stats.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/buffer_pool_stats.sql )</td>

<td>Buffer pool IO statistics</td>

</tr>

<tr>

<td>p 547</td>

<td>[db_cache_advice1.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/db_cache_advice1.sql )</td>

<td>Query on V$DB_CACHE_ADVICE</td>

</tr>

<tr>

<td>p 548</td>

<td>[db_cache_hist.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/db_cache_hist.sql )</td>

<td>DB cache advise shown as a histogram</td>

</tr>

<tr>

<td>p 552</td>

<td>[sga_dynamic_components.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/sga_dynamic_components.sql )</td>

<td>Query on V$SGA_DYNAMIC_COMPONENTS</td>

</tr>

<tr>

<td>p 551</td>

<td>[sga_resize_ops.sql](http://guyh.textdriven.com/OPSGSamples/Ch18/sga_resize_ops.sql )</td>

<td>Query on V$SGA_RESIZE_OPS</td>

</tr>

<tr>

<td>**Chapter 19: Optimizing PGA Memory**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 562</td>

<td>[pga_parameters.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/pga_parameters.sql )</td>

<td>PGA parameters and configuration from v$pgastat</td>

</tr>

<tr>

<td>p 566</td>

<td>[direct_temp_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/direct_temp_waits.sql )</td>

<td>temporary direct path IO compared to CPU and other non-idle waits</td>

</tr>

<tr>

<td>p 565</td>

<td>[top_pga.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/top_pga.sql )</td>

<td>Top consumers of PGA memory</td>

</tr>

<tr>

<td>p 567</td>

<td>[direct_io_delta_view_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/direct_io_delta_view_qry.sql )</td>

<td>Direct path temp IO over a time interval</td>

</tr>

<tr>

<td>p 570</td>

<td>[sql_workarea.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/sql_workarea.sql )</td>

<td>SQL workarea statistics</td>

</tr>

<tr>

<td>p 571</td>

<td>[pga_target_advice.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/pga_target_advice.sql )</td>

<td>PGA target advice report</td>

</tr>

<tr>

<td>p 572</td>

<td>[pga_advice_hist.sql](http://guyh.textdriven.com/OPSGSamples/Ch19/pga_advice_hist.sql )</td>

<td>PGA target advice histogram</td>

</tr>

<tr>

<td>**Chapter 20: Other Memory Management Topics**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 578</td>

<td>[io_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/io_waits.sql )</td>

<td>IO wait breakdown</td>

</tr>

<tr>

<td>p 581</td>

<td>[io_time_delta_view_qry.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/io_time_delta_view_qry.sql )</td>

<td>IO wait breakdown over a time period</td>

</tr>

<tr>

<td>p 582</td>

<td>[direct_path_trace_stats.pl](http://guyh.textdriven.com/OPSGSamples/Ch20/direct_path_trace_stats.pl)</td>

<td>Perl script to calculate average direct path IO time from a trace file</td>

</tr>

<tr>

<td>p 583</td>

<td>[pga_target_time.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/pga_target_time.sql )</td>

<td>PGA target converted to elapsed times</td>

</tr>

<tr>

<td>p 584</td>

<td>[overall_memory_advice.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/overall_memory_advice.sql )</td>

<td>Combined (PGA+SGA) memory advice report for 10g</td>

</tr>

<tr>

<td>p 586</td>

<td>[overall_memory11g.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/overall_memory11g.sql )</td>

<td>Combined (PGA+SGA) memory advice report for 11g</td>

</tr>

<tr>

<td>p 590</td>

<td>[memory_dynamic_components.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/memory_dynamic_components.sql )</td>

<td>V$MEMORY_DYNAMIC_COMPONENTS report</td>

</tr>

<tr>

<td>p 590</td>

<td>[memory_resize_ops.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/memory_resize_ops.sql )</td>

<td>V$MEMORY_RESIZE_OPS report</td>

</tr>

<tr>

<td>p 591</td>

<td>[memory_target_advice.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/memory_target_advice.sql )</td>

<td>Memory target advice report</td>

</tr>

<tr>

<td>p 593</td>

<td>[kmgsbsmemadv.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/kmgsbsmemadv.sql )</td>

<td>Query against X$KMSGSBSMEMADV (basis of V$MEMORY_TARGET_ADVICE)</td>

</tr>

<tr>

<td>p 594</td>

<td>[memory_parms.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/memory_parms.sql )</td>

<td>Report on memory related parameters</td>

</tr>

<tr>

<td>p 599</td>

<td>[result_cache_statistics.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/result_cache_statistics.sql )</td>

<td>Result set cache statistics</td>

</tr>

<tr>

<td>p 600</td>

<td>[rscache_hit_rate.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/rscache_hit_rate.sql )</td>

<td>Result set cache efficiency</td>

</tr>

<tr>

<td>p 600</td>

<td>[sql_cache_stats.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/sql_cache_stats.sql )</td>

<td>Result set cache statistics for SQL statements</td>

</tr>

<tr>

<td>p 601</td>

<td>[rc_dependencies.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/rc_dependencies.sql )</td>

<td>Result set cache dependencies</td>

</tr>

<tr>

<td>p 605</td>

<td>[shared_pool_advice.sql](http://guyh.textdriven.com/OPSGSamples/Ch20/shared_pool_advice.sql )</td>

<td>Shared pool advisory</td>

</tr>

<tr>

<td>**Chapter 21: Disk IO Tuning fundamentals**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 617</td>

<td>[io_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/io_waits.sql )</td>

<td>IO waits compared to other waits and CPU</td>

</tr>

<tr>

<td>p 618</td>

<td>[io_waits_delta.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/io_waits_delta.sql )</td>

<td>IO waits reported for an interval</td>

</tr>

<tr>

<td>p 619</td>

<td>[iostat_file.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/iostat_file.sql )</td>

<td>Summary report from v$iostat_file</td>

</tr>

<tr>

<td>p 620</td>

<td>[iostat_function.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/iostat_function.sql )</td>

<td>Summary report of v$iostat_function</td>

</tr>

<tr>

<td>p 622</td>

<td>[filestat.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/filestat.sql )</td>

<td>Summary report from v$filestat</td>

</tr>

<tr>

<td>p 622</td>

<td>[filemetric.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/filemetric.sql )</td>

<td>Short term IO statistics from v$filemetric</td>

</tr>

<tr>

<td>p 624</td>

<td>[calibrate_io.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/calibrate_io.sql )</td>

<td>PL/SQL reoutine to calibrate IO</td>

</tr>

<tr>

<td>p 623</td>

<td>[file_histogram.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/file_histogram.sql )</td>

<td>IO service time histogram</td>

</tr>

<tr>

<td>p 625</td>

<td>[dba_rsrc_io_calibrate.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/dba_rsrc_io_calibrate.sql )</td>

<td>Query IO calibration data</td>

</tr>

<tr>

<td>p 634</td>

<td>[lgwr_size.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/lgwr_size.sql )</td>

<td>Size of an average redo log IO</td>

</tr>

<tr>

<td>p 636</td>

<td>[log_file_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/log_file_waits.sql )</td>

<td>Report of redo log related waits</td>

</tr>

<tr>

<td>p 637</td>

<td>[log_history.sql](http://guyh.textdriven.com/OPSGSamples/Ch21/log_history.sql )</td>

<td>Log switch rates from v$log_history</td>

</tr>

<tr>

<td>**Chapter 22: Advanced IO techniques**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 645</td>

<td>[diskgroup_performance.sql](http://guyh.textdriven.com/OPSGSamples/Ch22/diskgroup_performance.sql )</td>

<td>ASM diskgroup IO throughput and service time</td>

</tr>

<tr>

<td>p 646</td>

<td>[asm_disk_performance.sql](http://guyh.textdriven.com/OPSGSamples/Ch22/asm_disk_performance.sql )</td>

<td>ASM disk-level throughput and service time</td>

</tr>

<tr>

<td>p 647</td>

<td>[asm_operations.sql](http://guyh.textdriven.com/OPSGSamples/Ch22/asm_operations.sql )</td>

<td>ASM rebalance operations in progress</td>

</tr>

<tr>

<td>p 647</td>

<td>[asm_files.sql](http://guyh.textdriven.com/OPSGSamples/Ch22/asm_files.sql )</td>

<td>ASM file level IO statistics</td>

</tr>

<tr>

<td>p 654</td>

<td>[asm_templates.sql](http://guyh.textdriven.com/OPSGSamples/Ch22/asm_templates.sql )</td>

<td>List all ASM templates</td>

</tr>

<tr>

<td>**Chapter 23: Optimizing RAC**</td>

<td></td>

<td></td>

</tr>

<tr>

<td>p 669</td>

<td>[top_level_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/top_level_waits.sql )</td>

<td>Break down of top level WAITCLASS waits</td>

</tr>

<tr>

<td>p 670</td>

<td>[cluster_waits.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/cluster_waits.sql )</td>

<td>Break out of cluster waits compared to other categories</td>

</tr>

<tr>

<td>p 671</td>

<td>[rac_waits_delta.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/rac_waits_delta.sql )</td>

<td>RAC waits over an interval of time</td>

</tr>

<tr>

<td>p 673</td>

<td>[avg_latency.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/avg_latency.sql )</td>

<td>Global cache latency report</td>

</tr>

<tr>

<td>p 674</td>

<td>[latency_delta.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/latency_delta.sql )</td>

<td>Global cache latency over a time period</td>

</tr>

<tr>

<td>p 675</td>

<td>[ksxpia.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/ksxpia.sql )</td>

<td>Private interconnect IP address</td>

</tr>

<tr>

<td>p 677</td>

<td>[gc_blocks_lost.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/gc_blocks_lost.sql )</td>

<td>Lost blocks report</td>

</tr>

<tr>

<td>p 681</td>

<td>[lms_latency.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/lms_latency.sql )</td>

<td>LMS latency breakdown</td>

</tr>

<tr>

<td>p 682</td>

<td>[flush_time.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/flush_time.sql )</td>

<td>redo log flush frequency and wait times</td>

</tr>

<tr>

<td>p 684</td>

<td>[balance.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/balance.sql )</td>

<td>Cluster balance report</td>

</tr>

<tr>

<td>p 685</td>

<td>[rac_balance_delta.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/rac_balance_delta.sql )</td>

<td>Cluster balance over a time period</td>

</tr>

<tr>

<td>p 689</td>

<td>[service_stats.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/service_stats.sql )</td>

<td>Report on service workload by instance</td>

</tr>

<tr>

<td>p 693</td>

<td>[gc_miss_rate.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/gc_miss_rate.sql )</td>

<td>"Global cache ""miss rate"" by instance "</td>

</tr>

<tr>

<td>p 694</td>

<td>[top_gc_segments.sql](http://guyh.textdriven.com/OPSGSamples/Ch23/top_gc_segments.sql )</td>

<td>Segments with the highest Global Cache activity</td>

</tr>

</tbody>

</table>
