select count(*) from sh.sales ; 
BEGIN
   opsg_dataload.addsales (2001, 2003);
   opsg_dataload.addsales (2001, 2004);
   opsg_dataload.addsales (2001, 2005);
   opsg_dataload.addsales (2001, 2006);
   opsg_dataload.addsales (2001, 2007);
   opsg_dataload.addsales (2001, 2008);
END;
/
select count(*) from sh.sales ; 

