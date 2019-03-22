
-- Search for blind bibs
SELECT 
* 
FROM 
sierra_view.bib_view

left join sierra_view.bib_record_item_record_link
on   bib_view.id = bib_record_item_record_link.bib_record_id

left join sierra_view.hold 
on bib_view.id = hold.record_id

LEFT JOIN sierra_view.bib_record_order_record_link
on bib_view.id = bib_record_order_record_link.bib_record_id

LEFT JOIN sierra_view.record_metadata
on bib_view.id = record_metadata.id

where

-- only bib records with no item
bib_record_item_record_link.bib_record_id is null AND

-- only bib records with bib holds. when commented out : might have hold, might not
-- hold.record_id is not null AND

-- only bib records without order records
bib_record_order_record_link.bib_record_id is null AND


-- filter out eAudio (o), eBook (q), Periodicals (s), Newspapers (n), Online database (m)
BIB_VIEW.BCODE2 NOT IN ('q', 'o', 's', 'n', 'm') AND

-- filter out suspended bib records
bib_view.bcode3 NOT IN ('n') 

-- filter out things created this calendar year
-- for instance, CDs that I put in from brief marc Midw to add
-- bib_view.record_creation_date_gmt < '2018-01-01'

order by
bib_view.record_creation_date_gmt
;