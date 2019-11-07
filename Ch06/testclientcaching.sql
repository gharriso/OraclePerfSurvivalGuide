select product_id,list_price,clientcaching.getprodprice(product_id) from oe.product_information  
 where list_price<>clientcaching.getprodprice(product_id)
