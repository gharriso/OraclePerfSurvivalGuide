/* Formatted on 2008/09/07 21:44 (Formatter Plus v4.8.7) */
COLUMN extension format a20
COLUMN extentions+name format a20
SET pagesize 1000
SET lines 100
SET echo on

SELECT extension_name, extension, density, num_distinct
  FROM all_stat_extensions e JOIN all_tab_col_statistics s
       ON (    e.owner = s.owner
           AND e.table_name = s.table_name
           AND e.extension_name = s.column_name
          )
 WHERE e.owner = 'SH' AND e.table_name IN ('CUSTOMERS', 'PRODUCTS')
 /

