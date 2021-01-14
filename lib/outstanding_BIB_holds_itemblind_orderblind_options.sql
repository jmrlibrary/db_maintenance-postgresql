-- This query has a great deal of overlap with 
-- TSHOLDS, and in fact is very similar except where
-- order create date would filter a record into 
-- one or the other pile. They are all part of a 
-- "holds cleanup" process which gets split
-- amongst departments.

-- However, it does also show bibs with no orders or items (totally blind)
-- with holds, so that's helpful

SELECT 
MIN (HOLDS.placed_gmt) as "minholddate",
MAX (HOLDS.placed_gmt) as "maxholddate",
CONCAT (BIBVIEW.record_type_code, BIBVIEW.record_num, 'a') as "brecnum",
MAX (BIBVIEW.title) as "title",
MAX (BIBVIEW.bcode2) AS "mattype",
-- MAX (PATRONVIEW.record_num) AS "precnum",

-- There's no way to definitively rule out all order records
-- "some are of the TSHOLDS variety", so we have to sort by 
-- ocreatedate and work our way backwards.
max (ORDERVIEW.record_creation_date_gmt) as "ocreatedate"

FROM

sierra_view.hold HOLDS

-- get a few bib view fields
LEFT JOIN sierra_view.bib_view BIBVIEW
on HOLDS.record_id = BIBVIEW.id 

-- Filter out staff cards
LEFT JOIN sierra_view.patron_record PATRONREC
on HOLDS.patron_record_id = PATRONREC.record_id

-- DISABLED : Get patron record number
-- LEFT JOIN sierra_view.patron_view PATRONVIEW
-- on PATRONVIEW.id = HOLDS.patron_record_id

-- filter bibs with no items
LEFT JOIN sierra_view.bib_record_item_record_link BIBITEMLINK
ON BIBVIEW.id = BIBITEMLINK.bib_record_id

-- DISABLED IN WHERE STATEMENT: filter bibs with no orders
-- STILL NEEDED TO LINK TO ORDER RECORD.
left join sierra_view.bib_record_order_record_link BIBORDERLINK
ON BIBVIEW.id = BIBORDERLINK.bib_record_id

-- get order create date
LEFT JOIN sierra_view.order_view ORDERVIEW
on ORDERVIEW.id = BIBORDERLINK.order_record_id

WHERE
PATRONREC.ptype_code != 18

-- itemblind bibs
AND BIBITEMLINK.bib_record_id IS NULL

-- orderblind bibs
--  AND bib_record_order_record_link.bib_record_id IS NULL

group by 
"brecnum"

ORDER BY
6 asc;
