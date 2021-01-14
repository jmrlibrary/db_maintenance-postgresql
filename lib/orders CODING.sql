SELECT 
  * 
FROM 
  sierra_view.order_view

  WHERE 
  received_date_gmt is null AND
  order_status_code != 'z'
  
  order by 
  order_date_gmt;
