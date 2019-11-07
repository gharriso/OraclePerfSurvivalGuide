/* Formatted on 2008/07/11 18:58 (Formatter Plus v4.8.7) */
DROP TYPE opsg_time_model_typ;
DROP TYPE opsg_time_model_line_typ;

CREATE OR REPLACE TYPE opsg_time_model_line_typ IS OBJECT (
   start_timestamp           DATE,
   end_timestamp             DATE,
   stat_name                 VARCHAR2 (256),
   total_waits               NUMBER,
   time_waited_micro         NUMBER,
   waits_per_second          NUMBER,
   microseconds_per_second   NUMBER
);
/

CREATE OR REPLACE TYPE opsg_time_model_typ IS TABLE OF opsg_time_model_line_typ;
/


