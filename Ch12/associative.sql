/* Formatted on 2008/09/24 08:54 (Formatter Plus v4.8.7) */
CREATE OR REPLACE PACKAGE associativedemo
IS
   PROCEDURE load_array;

   PROCEDURE load_cache;
   
   PROCEDURE load_cache_nodups;

   PROCEDURE scan_lookups (n_lookups NUMBER);

   FUNCTION get_cust_id (p_cust_name_dob VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cust_id_assoc (p_cust_name_dob VARCHAR2)
      RETURN NUMBER;

   PROCEDURE assoc_lookups (n_lookups NUMBER);
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY associativedemo
IS
   TYPE number_typ IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE varchar_typ IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   g_cust_ids           number_typ;
   g_cust_names_dob     varchar_typ;

   TYPE associative_typ IS TABLE OF NUMBER
      INDEX BY VARCHAR2 (1000);

   g_cust_assoc_array   associative_typ;

   PROCEDURE load_cache
   IS
   BEGIN
      SELECT cust_id,
             cust_first_name || ' ' || cust_last_name || ' '
             || cust_year_of_birth
      BULK COLLECT INTO g_cust_ids,
             g_cust_names_dob
        FROM sh.customers;
   END;

   PROCEDURE load_cache_nodups
   IS
   BEGIN
      SELECT   MAX (cust_id) cust_id,
                  cust_first_name
               || ' '
               || cust_last_name
               || ' '
               || cust_year_of_birth
      BULK COLLECT INTO g_cust_ids,
               g_cust_names_dob
          FROM sh.customers
      GROUP BY    cust_first_name
               || ' '
               || cust_last_name
               || ' '
               || cust_year_of_birth;
   END;

   PROCEDURE load_array
   IS
   BEGIN
      FOR i IN 1 .. g_cust_ids.COUNT
      LOOP
         g_cust_assoc_array (g_cust_names_dob (i)) := g_cust_ids (i);
      END LOOP;
   END;

   FUNCTION get_cust_id (p_cust_name_dob VARCHAR2)
      RETURN NUMBER
   IS
      v_cust_id   sh.customers.cust_id%TYPE;
   BEGIN
      FOR i IN 1 .. g_cust_names_dob.COUNT
      LOOP
         IF g_cust_names_dob (i) = p_cust_name_dob
         THEN
            v_cust_id := g_cust_ids (i);
            EXIT;
         END IF;
      END LOOP;

      RETURN (v_cust_id);
   END;

   FUNCTION get_cust_id_assoc (p_cust_name_dob VARCHAR2)
      RETURN NUMBER
   IS
      v_cust_id   sh.customers.cust_id%TYPE;
   BEGIN
      v_cust_id := g_cust_assoc_array (p_cust_name_dob);
      RETURN (v_cust_id);
   END;

   PROCEDURE scan_lookups (n_lookups NUMBER)
   IS
      v_cust_id     NUMBER;
      v_cust_name   VARCHAR2 (100);
      v_index       NUMBER;
      v_totals      NUMBER         := 0;
   BEGIN
      FOR i IN 1 .. n_lookups
      LOOP
         v_index := DBMS_RANDOM.VALUE (1, g_cust_ids.COUNT);
         v_cust_name := g_cust_names_dob (v_index);
         v_cust_id := get_cust_id (v_cust_name);
         v_totals := v_totals + v_cust_id;
      END LOOP;

      DBMS_OUTPUT.put_line (v_totals);
   END;

   PROCEDURE assoc_lookups (n_lookups NUMBER)
   IS
      v_cust_id     NUMBER;
      v_cust_name   VARCHAR2 (100);
      v_index       NUMBER;
      v_totals      NUMBER         := 0;
   BEGIN
      FOR i IN 1 .. n_lookups
      LOOP
         v_index := DBMS_RANDOM.VALUE (1, g_cust_ids.COUNT);
         v_cust_name := g_cust_names_dob (v_index);
         v_cust_id := get_cust_id_assoc (v_cust_name);
         v_totals := v_totals + v_cust_id;
      END LOOP;

      DBMS_OUTPUT.put_line (v_totals);
   END;
END;
/

SET echo on
SET timing on
SET serveroutput on
SPOOL associative

BEGIN
   associativedemo.load_cache_nodups;
   associativedemo.load_array;
END;
/

BEGIN
   associativedemo.scan_lookups (10000);
END;
/

BEGIN
   associativedemo.assoc_lookups (10000);
END;
/
exit;

