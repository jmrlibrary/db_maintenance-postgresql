select 

concat ('b', BIBVIEW.record_num, 'a') as "brecnum",
max(BIBVIEW.bcode3) as "bcode3",
max(BIBPROP.best_title) as "title",
max(BIBPROP.best_author) as "author",
min(HOLDS.placed_gmt)::date as "holdplaced",
count (case when (
  ITEMVIEW.item_status_code in ('-') 
  and CHECKOUT.due_gmt is null
  and ITEMVIEW.itype_code_num not in (1, 41) ) then ITEMVIEW.id end )
   as "availableitems",

count (ITEMVIEW.id) as "anyitems",
max(HOLDS.pickup_location_code) as "pickuplocationcode",

string_agg(IRP.barcode ||', ' || IRP.call_number_norm || ', ' || substring(itemview.location_code, 1, 1) || ', ' || ITEMVIEW.location_code , ' :: ') as "items"


from sierra_view.bib_view BIBVIEW

left join sierra_view.bib_record_item_record_link BILINK
on BIBVIEW.ID = BILINK.bib_record_id

left join sierra_view.item_view ITEMVIEW
on BILINK.item_record_id = ITEMVIEW.id

left join sierra_view.checkout CHECKOUT
on BILINK.item_record_id = CHECKOUT.item_record_id

join sierra_view.hold HOLDS
on BIBVIEW.ID = HOLDS.record_id

join sierra_view.bib_record_property BIBPROP
on BIBVIEW.ID = BIBPROP.bib_record_id

join sierra_view.item_record_property IRP
on ITEMVIEW.id = IRP.item_record_id


where 

HOLDS.patron_records_display_order = 0 

group by BIBVIEW.record_num

having 
count (case when (
ITEMVIEW.item_status_code in ('-') 
and CHECKOUT.due_gmt is null
and ITEMVIEW.itype_code_num not in (1, 41) ) then ITEMVIEW.id end ) > 0
and
count (ITEMVIEW.id) > 0

order by max(substring(ITEMVIEW.location_code, 1, 1)), min(HOLDS.placed_gmt)

;