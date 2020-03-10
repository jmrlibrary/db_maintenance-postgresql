select 

concat ('b', BIBVIEW.record_num, 'a') as "brecnum",
-- max(BIBVIEW.bcode3) as "bcode3",
max(BIBPROP.best_title) as "title",
max(BIBPROP.best_author) as "author",
count (case when ITEMVIEW.item_status_code in ('-', 't', '!') then ITEMVIEW.id end ) as "availableitems",
count (ITEMVIEW.id) as "anyitems",
max(OREC.order_date_gmt) as "latestorderdate"
-- , count(HOLDS.id) as "bibholdcount"

from sierra_view.bib_view BIBVIEW

left join sierra_view.bib_record_item_record_link BILINK
on BIBVIEW.ID = BILINK.bib_record_id

left join sierra_view.item_view ITEMVIEW
on BILINK.item_record_id = ITEMVIEW.id

join sierra_view.bib_record_property BIBPROP
on BIBVIEW.ID = BIBPROP.bib_record_id

left join sierra_view.bib_record_order_record_link BOLINK
on BIBVIEW.id = BOLINK.bib_record_id

left join sierra_view.order_record OREC
on BOLINK.order_record_id = OREC.record_id

left join sierra_view.hold HOLDS
on bibview.id = HOLDS.record_id

where 
BIBVIEW.bcode3 != 'n'

group by BIBVIEW.record_num

having 
count (case when ITEMVIEW.item_status_code in ('-', 't', '!') then ITEMVIEW.id end ) = 0
and
count (ITEMVIEW.id) > 0
 and count(HOLDS.id) = 0

order by  6 asc nulls first
;