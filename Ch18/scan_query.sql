      SELECT /*+ cache(ts) */
            txn_type, MAX(timestamp), SUM(sum_sales)
 FROM txn_summary ts 
      GROUP BY txn_type;
