SELECT 
min (hold.placed_gmt),
max (hold.placed_gmt),
concat( bib_view.record_type_code, bib_view.record_num, 'a') as bibrecnum,
min (bib_view.title),
MIN (BIB_VIEW.BCODE2) AS MATTYPE,
min ( patron_view.record_num),
max (order_view.record_creation_date_gmt) as ORDER_CREATE_DATE


FROM

SIERRA_VIEW.HOLD

LEFT JOIN
SIERRA_VIEW.BIB_VIEW
ON hold.record_id = BIB_view.id 

LEFT JOIN
sierra_view.patron_record
ON
hold.patron_record_id = patron_record.id

LEFT JOIN
sierra_view.bib_record_item_record_link
ON
bib_view.id = bib_record_item_record_link.bib_record_id

left join
sierra_view.bib_record_order_record_link
ON
bib_view.id = bib_record_order_record_link.bib_record_id

LEFT JOIN
sierra_view.order_view
on
order_view.id = bib_record_order_record_link.order_record_id


LEFT JOIN
sierra_view.patron_view
on
patron_view.id = patron_record.record_id



where 
patron_record.ptype_code != 18

-- itemblind bibs
 AND bib_record_item_record_link.bib_record_id IS NULL

-- orderblind bibs
--  AND bib_record_order_record_link.bib_record_id IS NULL


group by 
bibrecnum

-- having 


ORDER BY
7 ASC;
