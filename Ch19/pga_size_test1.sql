DROP TABLE pga_stats;

CREATE TABLE pga_stats (pga_target NUMBER,
stat_name VARCHAR2(1000), VALUE     NUMBER);

DECLARE
   pga_target     NUMBER := 50;
   pga_target_c   VARCHAR2(20);
BEGIN
   WHILE pga_target <= 2000 LOOP
      pga_target_c := TO_CHAR(pga_tar);

      EXECUTE IMMEDIATE   'alter system set pga_aggregate_target='
                       || pga_target
                       || 'M scope=memory';

      INSERT INTO pga_stats(pga_target, stat_name, VALUE)
         SELECT pga_target, ksppinm name, ksppstvl VALUE
         FROM    sys.x$ksppi
              JOIN
                 sys.x$ksppcv
              USING (indx)
         WHERE ksppinm IN
                     ('pga_aggregate_target',
                      '__pga_aggregate_target',
                      '_pga_max_size',
                      '_smm_max_size',
                      '_smm_px_max_size');

      commit; 
      pga_target := pga_target + 100;
   END LOOP;
END;
/
select * from pga_stats order by pga_target; 
