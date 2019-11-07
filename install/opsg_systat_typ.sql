DROP TYPE opsg_sysstat_typ;
DROP TYPE opsg_sysstat_line_typ;

CREATE OR REPLACE TYPE opsg_sysstat_line_typ IS
   OBJECT(start_timestamp DATE,
          end_timestamp DATE,
          name VARCHAR2(64),
          VALUE NUMBER,
          rate number);
/

CREATE OR REPLACE TYPE opsg_sysstat_typ IS TABLE OF opsg_sysstat_line_typ;
/


