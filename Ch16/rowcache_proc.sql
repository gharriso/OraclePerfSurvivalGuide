 create table x (y number);
      INSERT INTO X VALUES (1);
 
 CREATE OR REPLACE PROCEDURE cycle( cn number) IS
  MY NUMBER;
 BEGIN
   FOR I IN 0..cn LOOP
   BEGIN

     SELECT Y INTO MY FROM X WHERE ROWNUM <=1;
     COMMIT;
   END;
   END LOOP; 
 END cycle;
 /
