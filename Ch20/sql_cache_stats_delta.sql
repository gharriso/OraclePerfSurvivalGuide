SELECT SUM(DECODE(name, 'Create Count Success', VALUE)) created,
       SUM(DECODE(name, 'Find Count', VALUE)) find_count,
       SUM(DECODE(name, 'Invalidation Count', VALUE)) invalidated,
       SUM(DECODE(name, 'Delete Count Valid', VALUE)) delete_valid,
       SUM(DECODE(name, 'Delete Count Invalid', VALUE)) delete_invalid
     from table(opsg_result_cache.rscache_report());
