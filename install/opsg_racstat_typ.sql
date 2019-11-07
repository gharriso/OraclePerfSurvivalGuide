DROP TYPE opsg_racstat_typ;
DROP TYPE opsg_racstat_line_typ;

CREATE OR REPLACE TYPE opsg_racstat_line_typ IS
   OBJECT(start_timestamp DATE,
          end_timestamp DATE,
          inst_id number,
          name VARCHAR2(64),
          VALUE NUMBER,
          rate number);
/

CREATE OR REPLACE TYPE opsg_racstat_typ IS TABLE OF opsg_racstat_line_typ;
/
