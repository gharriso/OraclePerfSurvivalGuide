/* Formatted on 2007/08/03 11:35 (Formatter Plus v4.8.7) */
WITH PARAMETERS AS
     (
        SELECT x.inst_id, x.indx + 1 num, ksppinm NAME, ksppity TYPE,
               ksppstvl VALUE, ksppstdf isdefault,
               DECODE (BITAND (ksppiflg / 256, 1),
                       1, 'TRUE',
                       'FALSE'
                      ) iisses_modifiable,
               DECODE (BITAND (ksppiflg / 65536, 3),
                       1, 'IMMEDIATE',
                       2, 'DEFERRED',
                       3, 'IMMEDIATE',
                       'FALSE'
                      ) issys_modifiable,
               DECODE (BITAND (ksppstvf, 7),
                       1, 'MODIFIED',
                       4, 'SYSTEM_MOD',
                       'FALSE'
                      ) ismodified,
               DECODE (BITAND (ksppstvf, 2), 2, 'TRUE', 'FALSE') isadjusted,
               ksppdesc description, ksppstcmnt update_comment
          FROM x$ksppi x, x$ksppcv y
         WHERE (x.indx = y.indx))
SELECT *
  FROM PARAMETERS where description like '%direct%'
 
