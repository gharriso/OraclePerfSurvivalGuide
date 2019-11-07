CREATE TABLE calibrate_io_data(datetime DATE, elapsed NUMBER,
disks NUMBER, max_latency NUMBER, iops NUMBER, mbps NUMBER,
actual_latency NUMBER);

ALTER SESSION SET tracefile_identifier=calibrate_io;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
ALTER SYSTEM SET filesystemio_options='setall' SCOPE=SPFILE;

CREATE OR REPLACE PROCEDURE calibrate_test2(
    min_disks            NUMBER,
    max_disks            NUMBER,
    disk_increment       NUMBER 
) IS
    v_num_physical_disks   PLS_INTEGER;
    v_max_latency          PLS_INTEGER;
    v_max_iops             PLS_INTEGER;
    v_max_mbps             PLS_INTEGER;
    v_actual_latency       PLS_INTEGER;
    v_start                NUMBER;
    v_disks                NUMBER;
BEGIN
    v_disks := min_disks;

    WHILE v_disks <= max_disks LOOP

            v_start := DBMS_UTILITY.get_time();


            DBMS_RESOURCE_MANAGER.calibrate_io(num_physical_disks => v_disks,
            max_latency => 10, max_iops => v_max_iops,
            max_mbps => v_max_mbps,
            actual_latency => v_actual_latency);

            INSERT INTO calibrate_io_data(datetime, elapsed,
                                          disks, max_latency,
                                          iops, mbps,
                                          actual_latency)
            VALUES (SYSDATE,
                    (DBMS_UTILITY.get_time() - v_start) * 10,
                    v_disks, 10, v_max_iops,
                    v_max_mbps, v_actual_latency);

            COMMIT;
 
        v_disks := v_disks + disk_increment;
    END LOOP;
END;
/
begin   
    calibrate_test2(4,12,2); 
end; 
/

SELECT * FROM calibrate_io_data;
