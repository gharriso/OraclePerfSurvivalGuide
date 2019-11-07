/* Formatted on 2008/10/04 17:42 (Formatter Plus v4.8.7) */
SET echo on
SET lines 1000
SPOOL inlineDemo

CREATE OR REPLACE PACKAGE inline_demo
IS
   TYPE nt IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   g_sale       nt;
   g_discount   nt;
   PRAGMA inline (discount_rate_inline, 'YES');
   PRAGMA inline (discount_rate, 'NO');

   FUNCTION discount_rate_inline (p_sale_amount NUMBER)
      RETURN NUMBER;

   FUNCTION discount_rate (p_sale_amount NUMBER)
      RETURN NUMBER;

   PROCEDURE inlined;

   PROCEDURE not_inlined;

   PROCEDURE populate_array;

   PROCEDURE doitall;
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY inline_demo
IS
   PRAGMA inline (discount_rate_inline, 'YES');
   PRAGMA inline (discount_rate, 'NO');

   FUNCTION discount_rate (p_sale_amount NUMBER)
      RETURN NUMBER
   IS
      v_discount   NUMBER;
   BEGIN
      IF p_sale_amount > 1000
      THEN
         v_discount := p_sale_amount * .10;
      ELSIF p_sale_amount > 500
      THEN
         v_discount := p_sale_amount * .05;
      ELSE
         v_discount := 0;
      END IF;

      RETURN (v_discount);
   END;

   FUNCTION discount_rate_inline (p_sale_amount NUMBER)
      RETURN NUMBER
   IS
      v_discount   NUMBER;
   BEGIN
      IF p_sale_amount > 1000
      THEN
         v_discount := p_sale_amount * .10;
      ELSIF p_sale_amount > 500
      THEN
         v_discount := p_sale_amount * .05;
      ELSE
         v_discount := 0;
      END IF;

      RETURN (v_discount);
   END;

   PROCEDURE populate_array
   IS
   BEGIN
      SELECT amount_sold
      BULK COLLECT INTO g_sale
        FROM sh.sales;
   END;

   PROCEDURE inlined
   IS
   BEGIN
      FOR i IN 12 .. g_sale.COUNT
      LOOP
         g_discount (i) := discount_rate_inline (g_sale (i));
      END LOOP;
   END;

   PROCEDURE not_inlined
   IS
   BEGIN
      FOR i IN 12 .. g_sale.COUNT
      LOOP
         g_discount (i) := discount_rate (g_sale (i));
      END LOOP;
   END;

   PROCEDURE doitall
   IS
   BEGIN
      populate_array;
      inline_demo.inlined;
      inline_demo.not_inlined;
   END;
END;
/

SET echo on
SET timing on

BEGIN
   inline_demo.populate_array;
END;
/

BEGIN
   inline_demo.inlined;
END;
/

BEGIN
   inline_demo.not_inlined;
END;
/

BEGIN
   inline_demo.inlined;
END;
/

BEGIN
   inline_demo.not_inlined;
END;
/

