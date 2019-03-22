SELECT 
  bib_view.record_num, 
  bib_view.record_type_code
FROM 
  sierra_view.hold, 
  sierra_view.bib_record, 
  sierra_view.bib_view
WHERE 
  hold.record_id = bib_record.record_id AND
  bib_record.id = bib_view.id;



SELECT 
  item_view.record_num, 
  item_view.record_type_code, 
  bib_view.record_num, 
  bib_view.record_type_code
FROM 
  sierra_view.hold, 
  sierra_view.item_record, 
  sierra_view.item_view, 
  sierra_view.bib_record, 
  sierra_view.bib_view
WHERE 
  (hold.record_id = item_record.record_id AND item_record.id = item_view.id )
  OR
  (  hold.record_id = bib_record.record_id AND bib_record.id = bib_view.id)
  ;
