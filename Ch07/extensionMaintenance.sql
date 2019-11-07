/* Formatted on 2008/09/07 21:55 (Formatter Plus v4.8.7) */
SELECT ROUND (prod_list_price, -2)
  FROM sh.products;

BEGIN
   DBMS_STATS.gather_table_stats
      (ownname         => 'SH',
       tabname         => 'PRODUCTS',
       method_opt      => 'FOR ALL COLUMNS FOR COLUMNS (ROUND(prod_list_price,-2))'
      );
END;

/* Formatted on 2008/09/07 22:02 (Formatter Plus v4.8.7) */
BEGIN
   DBMS_STATS.drop_extended_stats (ownname        => 'SH',
                                   tabname        => 'PRODUCTS',
                                   extension      => '(ROUND(prod_list_price,-2))'
                                  );
END;

/
DECLARE 
    v_extension_name all_stat_extensions.extension_name%TYPE; 
BEGIN
  v_extension_name:=DBMS_STATS.create_extended_stats
                                   (ownname        => 'SH',
                                    tabname        => 'PRODUCTS',
                                    extension      => '(ROUND(prod_list_price,-2))'
                                   );
END;

