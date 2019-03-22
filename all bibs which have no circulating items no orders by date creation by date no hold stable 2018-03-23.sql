-- TO BE :
-- a list of all bibs which have no circulating items
-- and no nolds
-- and are not suppressed

-- Should display the bib 690 field (shows Local Voices)
-- and the 500 |x field ? (or wherever denoted as gift)

SELECT 
concat( bib_view.record_type_code, bib_view.record_num, 'a') as bibrecnum,
min (bib_view.title),
MIN (BIB_VIEW.BCODE2) AS MATTYPE,
min (bib_view.bcode3) as bibstatus,
max (hold.id) as Hold_ID,
max (order_record.order_date_gmt) AS ORDER_CREATE_DATE,
max (order_record.received_date_gmt) AS ORDER_RCD_DATE,
max (bib_view.record_creation_date_gmt) AS BIB_CREATE_DATE,
max (record_metadata.record_last_updated_gmt) as RECORD_LAST_UPDATED,
MAX (record_metadata.previous_last_updated_gmt) as PREVIOUS_LAST_UPDATED,

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
sierra_view.bib_view

LEFT JOIN
sierra_view.bib_record_item_record_link
ON
bib_view.id = bib_record_item_record_link.bib_record_id

LEFT JOIN
sierra_view.item_view
ON
item_view.id = bib_record_item_record_link.item_record_id

LEFT JOIN
sierra_view.hold
ON
(hold.record_id = item_view.id
OR
hold.record_id = BIB_VIEW.id
)

left join
sierra_view.patron_record
on
hold.patron_record_id = patron_record.id

left join
sierra_view.bib_record_order_record_link
on
bib_view.id = bib_record_order_record_link.bib_record_id

left join
sierra_view.order_record
on
bib_record_order_record_link.order_record_id = order_record.record_id

left join 
sierra_view.record_metadata
on
item_view.id = record_metadata.id

where 
bib_view.bcode3 not in ('n') 
-- AND patron_record.id not in (18)
and hold.id is null
AND bib_view.bcode2 not in ('q', 'o', 's', 'm', 'n', 'k')

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
6, 1,8;
