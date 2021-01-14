select 
concat (ITEMVIEW.record_type_code, ITEMVIEW.RECORD_NUM, 'a') as "irecnum",
HOLDS.placed_GMT as "holdplaced",
CIRC.due_date_gmt as "duedate",
Trim(
REGEXP_REPLACE ( 
    ITEMPROP.call_number , '\|\w', ' ', 'g'
    )  
    )as "callnum",
ITEMVIEW.item_status_code as "istatuscode",
PATRONVIEW.ptype_code as "ptypecode",
(ITEMVIEW.barcode) as "barcode",
  (ITEMVIEW.location_code) as "loc",
  (ITEMVIEW.itype_code_num) as "itype",
  (ITEMVIEW.last_checkout_gmt) as "lastcheckout",
  --  (BRECPROP.best_author) as "author",
 --  (BRECPROP.best_title) as "title"
 'author' as "author",
 'title' as "title"

from sierra_view.hold HOLDS

join sierra_view.item_view ITEMVIEW
on HOLDS.record_id = ITEMVIEW.id


--join sierra_view.bib_record_item_record_link BIBITEMLINK
--on ITEMVIEW.id = BIBITEMLINK.item_record_id

--join sierra_view.bib_record_property BRECPROP
--on BIBITEMLINK.bib_record_id = BRECPROP.bib_record_id

join sierra_view.item_record_property ITEMPROP
on ITEMVIEW.id = ITEMPROP.item_record_id

join sierra_view.patron_view PATRONVIEW
on HOLDS.patron_record_id = PATRONVIEW.id

left join sierra_view.circ_trans CIRC
on itemview.id = CIRC.item_record_id

where 
-- unavailable by status
ITEMVIEW.item_status_code not in ('-', '!', 't')
and ITEMVIEW.itype_code_num not in (100)
and PATRONVIEW.ptype_code != 18
and HOLDS.placed_GMT < now() - interval '2 month'
;