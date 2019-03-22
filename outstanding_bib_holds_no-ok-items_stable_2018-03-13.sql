-- does NOT catch bibs without items

SELECT 
min (hold.placed_gmt),
concat( bib_view.record_type_code, bib_view.record_num, 'a') as bibrecnum,
--item_view.item_status_code
min (bib_view.title),
MIN (BIB_VIEW.BCODE2) AS MATTYPE,

sum (
CASE
when item_view.item_status_code IN ('-', '!', 't')
then 1
else 0
end) as OKITEMS,

sum(
CASE
when item_view.item_status_code NOT IN ('-', '!', 't')
then 1
else 0
end) as NOTOKITEMS


FROM
sierra_view.bib_view,
sierra_view.hold,
sierra_view.patron_record,
sierra_view.bib_record_item_record_link,
sierra_view.item_view

where 
hold.record_id = bib_view.id AND
hold.patron_records_display_order = 0 AND
--item_view.item_status_code NOT IN ('-', '!', 't') AND
hold.patron_record_id = patron_record.id AND
patron_record.ptype_code != 18 AND
bib_view.id = bib_record_item_record_link.bib_record_id  AND
item_view.id = bib_record_item_record_link.item_record_id

group by 
bibrecnum

having 
sum (
CASE
when item_view.item_status_code IN ('-', '!', 't')
then 1
else 0
end) = 0

ORDER BY
-- item_view.item_status_code,
1;
