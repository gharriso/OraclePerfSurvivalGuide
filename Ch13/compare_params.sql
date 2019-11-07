drop database link db10g; 
CREATE DATABASE LINK db10g CONNECT TO opsg IDENTIFIED BY opsg USING 'MELRACDB';
CREATE DATABASE LINK db11gR2 CONNECT TO opsg IDENTIFIED BY opsg USING 'G11R2';

WITH p10g AS (SELECT   name, description, 'TRUE' supported   
                FROM   v$parameter@db10g
               WHERE   name LIKE 'parallel%'),
    p11g AS (SELECT   name, description, 'TRUE' supported
               FROM   v$parameter
              WHERE   name LIKE 'parallel%'),
    p11gR2 AS (SELECT   name, description, 'TRUE' supported
                 FROM   v$parameter@db11gR2
                WHERE   name LIKE 'parallel%')
SELECT   name, p11gR2.description, p10g.supported supported10g,
         p11g.supported supported11g,p11gR2.supported supported11gR2
  FROM         p10g
            FULL OUTER JOIN
               p11g
            USING (name)
         FULL OUTER JOIN
            p11gR2
         USING (name)
order by name;

select * from v$parameter@db11gR2 where name like 'parallel%' order by name 
/* Formatted on 30-Dec-2008 8:48:20 (QP5 v5.120.811.25008) */
