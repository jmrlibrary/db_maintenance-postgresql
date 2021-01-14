SELECT 
bib_record.record_id,
count(bib_record_item_record_link.item_record_id)
FROM 
sierra_view.bib_record, 
sierra_view.bib_record_item_record_link, 
sierra_view.item_record
WHERE 
bib_record_item_record_link.bib_record_id = bib_record.record_id AND
bib_record_item_record_link.item_record_id = item_record.record_id

group by
bib_record.record_id

having
count(bib_record_item_record_link.item_record_id) > 1;
