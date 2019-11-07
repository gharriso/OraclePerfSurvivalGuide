SELECT ksppinm NAME, ksppstvl VALUE, ksppdesc description
  FROM x$ksppi x  JOIN x$ksppcv y
  USING (indx)
WHERE ksppinm = '__pga_aggregate_target' OR ksppinm = '__sga_target'
  or ksppinm='memory_target' 
  order by ksppinm

