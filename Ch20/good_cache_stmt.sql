select /*+ result_cache */ sum(amount_sold) from sales where channel_id=3; 

