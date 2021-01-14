SELECT 
hold.placed_gmt,
concat( item_view.record_type_code, item_view.record_num, 'a'),
item_view.item_status_code

FROM
sierra_view.item_view,
sierra_view.hold,
sierra_view.patron_record

where 
hold.record_id = item_view.id AND
hold.patron_records_display_order = 0 AND
item_view.item_status_code NOT IN ('-', '!', 't') AND
hold.patron_record_id = patron_record.id AND
patron_record.ptype_code != 18

ORDER BY
item_view.item_status_code,
hold.placed_gmt;
