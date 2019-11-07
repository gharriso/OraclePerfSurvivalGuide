CREATE or replace PROCEDURE read_transim IS
    v_start   NUMBER;
    v_stop    NUMBER;
BEGIN
    SELECT MIN(order_id), MAX(order_id)
    INTO v_start, v_stop
    FROM transim.g_orders;

    LOOP
        FOR i IN v_start .. v_stop LOOP
            BEGIN
                FOR r IN (SELECT *
                          FROM transim.g_orders
                          WHERE order_id = i) LOOP
                    NULL;
                END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END LOOP;
    END LOOP;
END;
/
