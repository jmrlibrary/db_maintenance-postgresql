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
