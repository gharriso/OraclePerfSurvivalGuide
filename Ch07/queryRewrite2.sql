alter session set tracefile_identifier=query_rewrite;

alter session set events '10053 trace name context forever';
 
SELECT location_id
  FROM hr.locations
 WHERE city = 'Sydney'
    OR city = 'London'; 

 
