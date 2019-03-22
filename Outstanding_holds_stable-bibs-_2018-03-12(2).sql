SELECT 
min (hold.placed_gmt),
concat( bib_view.record_type_code, bib_view.record_num, 'a') as bibrecnum
--item_view.item_status_code

FROM
sierra_view.bib_view,
sierra_view.hold,
sierra_view.patron_record

where 
hold.record_id = bib_view.id AND
hold.patron_records_display_order = 0 AND
--item_view.item_status_code NOT IN ('-', '!', 't') AND
hold.patron_record_id = patron_record.id AND
patron_record.ptype_code != 18

group by 
bibrecnum

ORDER BY
-- item_view.item_status_code,
1;
