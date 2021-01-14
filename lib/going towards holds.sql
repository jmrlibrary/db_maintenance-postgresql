SELECT 
CONCAT (order_view.record_type_code, order_view.record_num, 'a') AS RECNUM,
order_record_cmf.copies AS NUMCOPIES,
bib_record_property.material_code AS FORMAT,
bib_record_property.best_title, 
bib_record_property.best_author,
bib_record_order_record_link.order_record_id,
order_record.received_date_gmt AS Received,
hold.record_id,
hold.placed_gmt AS Held,

CASE 
WHEN hold.placed_gmt > order_record.received_date_gmt
THEN '2018-02-17' - hold.placed_gmt 
ELSE
'2018-02-17' - order_record.received_date_gmt
END
AS DIFF

FROM 
sierra_view.bib_record_property

FULL OUTER JOIN
sierra_view.bib_record_item_record_link

ON 
bib_record_property.bib_record_id = bib_record_item_record_link.bib_record_id

FULL OUTER JOIN
sierra_view.bib_record_order_record_link

ON
bib_record_property.bib_record_id = bib_record_order_record_link.bib_record_id

FULL OUTER JOIN
sierra_view.order_record

ON
bib_record_order_record_link.order_record_id = order_record.record_id

FULL OUTER JOIN
sierra_view.order_view

ON
order_record.record_id = order_view.record_id

FULL OUTER JOIN
sierra_view.order_record_cmf

ON
order_record.record_id = order_record_cmf.order_record_id

FULL OUTER JOIN
sierra_view.hold

ON
bib_record_property.bib_record_id = hold.record_id

WHERE 
bib_record_item_record_link.bib_record_id IS NULL AND
bib_record_order_record_link.bib_record_id IS NOT NULL AND
order_record.received_date_gmt IS NOT NULL AND
hold.record_id IS NOT NULL AND
order_record_cmf.display_order = 0
-- AND
-- bib_record_property.best_title = 'Haikyu! 19'

ORDER BY
recnum DESC;

