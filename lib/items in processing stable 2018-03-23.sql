SELECT 
  concat ('i', item_view.record_num, 'a')
FROM 
  sierra_view.item_view

  where 
  item_view.item_status_code in ('p')
  ;
