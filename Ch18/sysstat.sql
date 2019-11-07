select translate(name,' ','_'),name,value from v$sysstat 
 where  name in ( 'consistent gets','consistent gets direct','consistent gets from cache',
    'db block gets','db block gets direct','db block gets from cache','physical reads','physical reads cache','physical reads direct') 
order by name 
