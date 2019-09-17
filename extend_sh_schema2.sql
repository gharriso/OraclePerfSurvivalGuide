SELECT COUNT( * ) FROM sh.sales;

BEGIN
    opsg_dataload.addsales(2001, 2010);
    opsg_dataload.addsales(2000, 2011);
    opsg_dataload.addsales(2001, 2012);
    opsg_dataload.addsales(2001, 2013);
        opsg_dataload.addsales(2001, 2015);
 END;
/

SELECT COUNT( * ) FROM sh.sales;
