
-- Search for blind bibs
SELECT 
  * 
FROM 
sierra_view.bib_view
  
  left join sierra_view.bib_record_item_record_link
  on   bib_view.id = bib_record_item_record_link.bib_record_id

where
bib_record_item_record_link.bib_record_id is null

;