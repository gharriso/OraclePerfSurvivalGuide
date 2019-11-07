/* Formatted on 2008/08/30 10:49 (Formatter Plus v4.8.7) */
DECLARE
   TYPE xtype IS TABLE OF arrayinserttest.x%TYPE
      INDEX BY BINARY_INTEGER;

   TYPE ytype IS TABLE OF arrayinserttest.y%TYPE
      INDEX BY BINARY_INTEGER;

   xlist   xtype;
   ylist   ytype;
BEGIN
   FOR i IN 1 .. 100
   LOOP
      xlist (i) := i;
      ylist (i) := 'This is number ' || i;
   END LOOP;

   FORALL i IN 1 .. xlist.COUNT
      INSERT INTO arrayinserttest
                  (x, y
                  )
           VALUES (xlist (i), ylist (i)
                  );
END;

