DECLARE
    v_amt     NUMBER;
    t_custs   DBMS_SQL.number_table;
    t_prods   DBMS_SQL.number_table;
BEGIN
    SELECT cust_id
    BULK COLLECT
    INTO t_custs
    FROM sh.customers;

    SELECT prod_id
    BULK COLLECT
    INTO t_prods
    FROM sh.products;

    FOR i IN 1 .. &1  LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT SUM(amount_sold) FROM sh.sales WHERE cust_id='
                             || t_custs(ROUND(DBMS_RANDOM.VALUE(1,
                                              t_custs.COUNT)))
                             || ' AND prod_id='
                             || t_prods(ROUND(DBMS_RANDOM.VALUE(1,
                                              t_prods.COUNT)))
                INTO v_amt;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END LOOP;
END;
/
