SELECT SUM(DECODE(name, 'Create Count Success', VALUE)) created,
       SUM(DECODE(name, 'Find Count', VALUE)) find_count,
       SUM(DECODE(name, 'Invalidation Count', VALUE)) invalidated,
       SUM(DECODE(name, 'Delete Count Valid', VALUE)) delete_valid,
       SUM(DECODE(name, 'Delete Count Invalid', VALUE)) delete_invalid
FROM v$result_cache_statistics;
/* Formatted on 2/03/2009 1:51:07 PM (QP5 v5.120.811.25008) */
