SELECT filetype_name, COUNT( * ), asynch_io
FROM v$iostat_file
GROUP BY filetype_name, asynch_io
/* Formatted on 11/02/2009 7:57:05 AM (QP5 v5.120.811.25008) */
