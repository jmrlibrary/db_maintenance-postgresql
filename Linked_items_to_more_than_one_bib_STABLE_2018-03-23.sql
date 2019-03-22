SELECT 
COUNT(bib_record_item_record_link.bib_record_id) as bib_count,
concat('i', item_view.record_num, 'a') as item_rec_num

FROM 
sierra_view.bib_record_item_record_link, 
sierra_view.item_view

WHERE 
bib_record_item_record_link.item_record_id = item_view.id

GROUP BY
item_rec_num

having
COUNT(bib_record_item_record_link.bib_record_id) > 1

ORDER BY
bib_count DESC;