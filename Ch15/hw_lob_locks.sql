alter session set tracefile_identifier=hw_lock;
alter session set events '10046 trace name context forever, level 8';

DROP TABLE log_table purge;

CREATE TABLE log_table(pk INT , log_data1 VARCHAR2(4000),
log_data2 VARCHAR2(4000), log_data3 VARCHAR2(4000),
log_data4 VARCHAR2(4000), log_data5 VARCHAR2(4000),
log_data6 VARCHAR2(4000)) nologging;

CREATE SEQUENCE lob_seq
    CACHE 10000;

DECLARE
    v_lob_data   CLOB;
BEGIN
    SELECT RPAD('x', 4000, 'x') INTO v_lob_data FROM DUAL;

    FOR i IN 1 .. &1 LOOP
        INSERT INTO log_table(pk, log_data1, log_data2, log_data3, log_data4, log_data5, log_data6)
            SELECT lob_seq.NEXTVAL+rownum, v_lob_data, v_lob_data, v_lob_data,
                   v_lob_data, v_lob_data, v_lob_data
            FROM DUAL connect by rownum <&2;
        if (mod(i,100)=0 ) then 
            commit;
        end if; 
    END LOOP;
END;
/
select * from log_table; 
