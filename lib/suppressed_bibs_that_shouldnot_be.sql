-- weekly. last run 7/9/2020
-- only returns bibs with at least 1 item (?)

select 
max(BIBITEMLINK.bib_record_id) as "iiibrecid",
max( concat(ITEMVIEW.record_type_code, ITEMVIEW.record_num, 'a')) as "irecnum",
max( concat(BIBVIEW.record_type_code, BIBVIEW.record_num, 'a')) as "brecnum",
max( ITEMVIEW.item_status_code) as "istatuscode",
MAX (ITEMVIEW.itype_code_num) AS "itypecode",
MAX (cast (BIBVIEW.is_available_at_library as varchar)) as "bisavail"

-- Can leave this out, as I filter against it.
-- MAX (BIBVIEW.bcode3) as "bcode3"

-- I'm also not pulling STATUS : DUE date, because then I have 
-- to join the circ data table, and I don't want to, and I 
-- don't think It's necessary.

from sierra_view.bib_record_item_record_link BIBITEMLINK

left join sierra_view.item_view ITEMVIEW
on BIBITEMLINK.item_record_id = ITEMVIEW.id

LEFT JOIN sierra_view.bib_view BIBVIEW
on BIBITEMLINK.bib_record_id = BIBVIEW.id

where
-- item is not available, on hold shelf, or in transit
ITEMVIEW.item_status_code IN ('-', '!', 't')

-- item is not suppressed
AND ITEMVIEW.icode2 NOT IN ('n')

-- item is not certain types of items
AND ITEMVIEW.itype_code_num NOT IN (60, 50, 62, 54, 53, 1, 0, 25, 26, 27, 0, 70, 72, 100, 77, 99)

-- item is not in professional collections
AND ITEMVIEW.location_code NOT IN ('apc', 'cpc', 'gpc', 'lpc', 'mjpc', 'mpc', 'npc', 'rpc', 'spc')

-- bib is suppressed
AND "bcode3" = 'n'

GROUP BY
BIBITEMLINK.bib_record_id 

order by 4
;