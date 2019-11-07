DROP TYPE opsg_servstat_typ;
DROP TYPE opsg_servstat_line_typ;

CREATE OR REPLACE TYPE opsg_servstat_line_typ IS
   OBJECT(start_timestamp DATE,
          end_timestamp DATE,
          inst_id number,
          service_name VARCHAR2(100),
          stat_name VARCHAR2(100),
          value number);
/

CREATE OR REPLACE TYPE opsg_servstat_typ IS TABLE OF opsg_servstat_line_typ;
/
