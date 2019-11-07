drop table sales;
create table sales as select * from sh.sales;
create index sales_channel_bitmap_idx on sales(channel_id); 

select distinct channel_id from sales; 
