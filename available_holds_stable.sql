SELECT 

hold.note,
item_record.item_status_code, 
patron_view.record_type_code, 
patron_view.record_num, 
item_view.record_type_code, 
item_view.record_num, 
item_view.last_checkin_gmt,
checkout.due_gmt,
checkout.overdue_count,
checkout.overdue_gmt,
item_record_Property.barcode,
substr(item_record_property.call_number, 3, length(item_record_property.call_number)-2) as CALLNUM,
item_view.location_code,
bib_record_property.best_title,
bib_record_property.best_author,
hold.pickup_location_code,
left(item_view.location_code,1) AS CHARloc,
hold.placed_gmt,

CASE
WHEN substr(item_record_property.call_number,3,1) = 'J' or substr(item_view.location_code, 2, 1) = 'j'
THEN '1J'

WHEN RIGHT(item_view.location_code,2) = 'nb'
THEN '1Z'

WHEN left(item_view.location_code,3) = 'mya'
THEN '1Y'

WHEN LEFT (item_view.location_code,3) = 'mgn'
THEN '1Z' -- MAIN FLOOR CIRC

WHEN LEFT (item_view.location_code,5) = 'mlang'
THEN '1Z' -- MAIN FLOOR CIRC

WHEN substr (item_record_property.call_number,3, 3) = '92 '
THEN '2ZNB' -- DOWNSTAIRS CIRC, END OF NONFICTION (NF B)

WHEN LEFT (item_view.location_code,3) = 'mtp'
THEN '2ZA' -- DOWNSTAIRS CIRC, A

WHEN LEFT (item_view.location_code,3) = 'mpt'
THEN '1J' -- 

WHEN LEFT (item_view.location_code,3) = 'mms' AND substr(item_record_property.call_number, 3, 7) SIMILAR TO 'TB CD [0-9]'
THEN '2ZNA'

WHEN LEFT (item_view.location_code,3) = 'mms' AND substr(item_record_property.call_number, 3, 1) SIMILAR TO '[A-Z]'
THEN '1Z'

WHEN LEFT (item_view.location_code,3) = 'mms' AND substr(item_record_property.call_number, 3, 1) SIMILAR TO '[0-9]'
THEN '2ZNA'

END AS PICKDEPT



FROM 
sierra_view.hold

LEFT JOIN   
sierra_view.item_record
ON   hold.record_id = item_record.record_id

LEFT JOIN
sierra_view.item_view
ON
item_record.id = item_view.id

LEFT JOIN   sierra_view.patron_record
ON   hold.patron_record_id = patron_record.record_id

LEFT JOIN  sierra_view.patron_view
ON patron_view.id = patron_record.id

left join sierra_view.checkout
ON   hold.record_id = checkout.item_record_id

left join sierra_view.item_record_property
ON item_record.record_id = item_record_property.item_record_id

LEFT JOIN sierra_view.bib_record_item_record_link
ON bib_record_item_record_link.item_record_id = item_record.record_id

LEFT JOIN sierra_view.bib_record_property
ON bib_record_item_record_link.bib_record_id = bib_record_property.bib_record_id

WHERE 


hold.record_id = item_record.record_id AND
hold.patron_record_id = patron_record.record_id AND
item_record.id = item_view.id AND
patron_view.id = patron_record.id AND

ITEM_RECORD.ITEM_STATUS_CODE NOT IN ('t','!', 'm', 'n', 'o', 'z', '$') AND

patron_view.ptype_code NOT IN (18) AND
-- and exclude "checked out to" any of these (that should be another list, though)


item_record.itype_code_num NOT IN (100) AND -- ILLs

item_view.record_num NOT IN ( -- JMRL toy library
2192774,
2192985,
2193058,
2193096,
2193099,
2192781,
2193098,
2193873,
2193882,
2193885,
2192982,
2193022,
2193038,
2193887,
2193888,
2192980,
2193047,
2193090,
2193102,
2193875,
2192778,
2192785,
2193876,
2193881,
2193884,
2192780,
2192983,
2193026,
2193103,
2193872,
2192779,
2192782,
2193021,
2193100,
2193883,
2192777,
2193043,
2193097,
2193101,
2193886,

-- Kajeet smartSpots
2175173,
2175165,
2184580,
2175168,
2175166,
2175171,
2175169,
2175170,
2175172,
2175167
)







ORDER BY
-- ITEM_RECORD.ITEM_STATUS_CODE ,
-- HOLD.PLACED_GMT
-- item_view.last_checkin_gmt
CHECKOUT.DUE_GMT,
charloc,
PICKDEPT,
item_view.location_code,
CALLNUM;


  

  
