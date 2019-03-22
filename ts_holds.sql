SELECT 
  order_record.received_date_gmt, 
  hold.placed_gmt, 
  bib_record_property.best_title, 
  bib_record_property.best_author
FROM 
  sierra_view.bib_record, 
  sierra_view.bib_record_item_record_link, 
  sierra_view.hold, 
  sierra_view.order_record, 
  sierra_view.bib_record_property, 
  sierra_view.bib_record_order_record_link
WHERE 
  bib_record.record_id = bib_record_item_record_link.bib_record_id AND
  bib_record.record_id = hold.record_id AND
  bib_record.record_id = bib_record_item_record_link.bib_record_id AND
  bib_record.record_id = bib_record_property.bib_record_id AND
  bib_record.record_id = bib_record_order_record_link.bib_record_id AND
  bib_record_order_record_link.order_record_id = order_record.record_id AND
  order_record.received_date_gmt > '2017-07-01' AND 
  hold.id IS NOT NULL  AND 
  bib_record_item_record_link.id IS NULL ;
