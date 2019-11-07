spool nocopy_test 

CREATE OR REPLACE PACKAGE nocopy_test
IS
   TYPE number_tab_type IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   my_number_table   number_tab_type;

   PROCEDURE init (row_count NUMBER);

   PROCEDURE put_avalue (
      p_input_table   IN OUT   number_tab_type,
      p_row                    NUMBER,
      p_col                    NUMBER,
      p_num_cols               NUMBER,
      p_value                  NUMBER
   );

   FUNCTION get_avalue (
      p_input_table   IN OUT   number_tab_type,
      p_row                    NUMBER,
      p_col                    NUMBER,
      p_num_cols               NUMBER
   )
      RETURN NUMBER;

   PROCEDURE test_copy_nv (row_count NUMBER, iter NUMBER);

   PROCEDURE test_copy (row_count NUMBER, iter NUMBER); 
END;                                                           -- Package spec
/

CREATE OR REPLACE PACKAGE BODY nocopy_test
IS
   PROCEDURE init (row_count NUMBER)
   IS
   BEGIN
      FOR i IN 1 .. row_count
      LOOP
         FOR j IN 1 .. 10
         LOOP
            put_avalue (my_number_table, i, j, 10, MOD (i, j));
         END LOOP;
      END LOOP;
   END;

   FUNCTION get_avalue (
      p_input_table   IN OUT   number_tab_type,
      p_row                    NUMBER,
      p_col                    NUMBER,
      p_num_cols               NUMBER
   )
      RETURN NUMBER
   IS
      l_index   NUMBER;
   BEGIN
      l_index := ((p_row - 1) * p_num_cols) + p_col;
      RETURN (p_input_table (l_index));
   END;

   FUNCTION get_avalue_nv (
      p_input_table   IN OUT NOCOPY   number_tab_type,
      p_row                           NUMBER,
      p_col                           NUMBER,
      p_num_cols                      NUMBER
   )
      RETURN NUMBER
   IS
      l_index   NUMBER;
   BEGIN
      l_index := ((p_row - 1) * p_num_cols) + p_col;
      RETURN (p_input_table (l_index));
   END;

   PROCEDURE put_avalue (
      p_input_table   IN OUT NOCOPY   number_tab_type,
      p_row                           NUMBER,
      p_col                           NUMBER,
      p_num_cols                      NUMBER,
      p_value                         NUMBER
   )
   IS
      l_index   NUMBER;
   BEGIN
      l_index := ((p_row - 1) * p_num_cols) + p_col;
      p_input_table (l_index) := p_value;
   END;

   PROCEDURE test_copy_nv (row_count NUMBER, iter NUMBER)
   IS
      x   NUMBER;
   BEGIN
      FOR h IN 1 .. iter
      LOOP
         FOR i IN 1 .. row_count
         LOOP
            FOR j IN 1 .. 10
            LOOP
               x := get_avalue_nv (my_number_table, i, j, 10);
            END LOOP;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE test_copy (row_count NUMBER, iter NUMBER)
   IS
      x   NUMBER;
   BEGIN
      FOR h IN 1 .. iter
      LOOP
         FOR i IN 1 .. row_count
         LOOP
            FOR j IN 1 .. 10
            LOOP
               x := get_avalue (my_number_table, i, j, 10);
            END LOOP;
         END LOOP;
      END LOOP;
   END;
END;
/

SET echo on
SET timing on

BEGIN
   nocopy_test.init (4000);
END;
/

BEGIN
   nocopy_test.test_copy_nv (4000, 10);
END;
/

BEGIN
   nocopy_test.test_copy (4000, 10);
END;
/

