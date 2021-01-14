/**

WARNING: MANY OF THESE RECORDS, ESPECIALLY IF ADDED RECENTLY ARE 
RECORDS THAT CATALOGERS ARE USING OR WORKING ON, WHICH WILL SUBSEQUENTLY
OVERWRITE STUBB RECORDS.

BE VERY CAREFUL BEFORE DELETING: EITHER JUST SUPPRESS, OR MAKE EXPORT/BACKUPS
OF BIB RECORDS, ESPECIALLY IF PLANNING TO BATCH DELETE 
(WHICH YOU PROBABLY SHOULDN'T DO ANYWAY)

*/


-- Search for blind bibs
SELECT 
sv.content as "049__|a",
bib_view.record_type_code || bib_view.record_num || 'a' as record_key,
record_metadata.record_last_updated_gmt,
record_metadata.previous_last_updated_gmt,
record_metadata.creation_date_gmt,
bib_record_order_record_link.bib_record_id as "has_order_record_linked"
bib_view.*

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

left join sierra_view.subfield_view sv
on sv.record_id = bib_view.id

where

-- only get the 049 $a subfield to see if PDV (hence cataloged)
sv.marc_tag = '049' and sv.tag = 'a'
and 

-- only bib records with no item
bib_record_item_record_link.bib_record_id is null AND

-- only bib records with bib holds. when commented out : might have hold, might not
hold.record_id is not null AND

-- only bib records without order records
-- bib_record_order_record_link.bib_record_id is null AND


-- filter out eAudio (o), eBook (q), Periodicals (s), Newspapers (n), Online database (m), kits
BIB_VIEW.BCODE2 NOT IN ('q', 'o', 's', 'n', 'm', 'k') AND

-- filter out suppressed bib records
bib_view.bcode3 NOT IN ('n') 

-- filter out things created this calendar year
-- for instance, CDs that I put in from brief marc Midw to add
-- bib_view.record_creation_date_gmt < '2018-01-01'

order by
bib_view.record_creation_date_gmt
;