
-- get all bib holds from hold table
-- (altho there is a difference between grouping by
-- the iii bib id, and pre-filtering by 
-- patron_record_display_order = 0
with bib_holds as (

select BIBVIEW.ID as iii_bib_id

from 
sierra_view.bib_view BIBVIEW,
sierra_view.hold HOLDS

where BIBVIEW.ID = HOLDS.record_id
and HOLDS.patron_records_display_order = 0

group by BIBVIEW.ID

),


 item_holds as (
select 
bib_holds.iii_bib_id as iii_bib_id,

count (case when (
  ITEMVIEW.item_status_code in ('-') 
  and (CHECKOUT.due_gmt is null or CHECKOUT.due_gmt <= '1970-01-01'::date)
  and HOLDS.record_id is null
  and ITEMVIEW.itype_code_num not in (1, 41) ) then ITEMVIEW.id end )
  as "availableitems",

 count (ITEMVIEW.id) as "anyitems"

from 
bib_holds
join 
sierra_view.bib_record_item_record_link BILINK
on iii_bib_id = BILINK.bib_record_id
join sierra_view.item_view ITEMVIEW
on BILINK.item_record_id = ITEMVIEW.id
left join sierra_view.checkout CHECKOUT
on BILINK.item_record_id = CHECKOUT.item_record_id
left join sierra_view.hold  HOLDS 
on HOLDS.record_id = BILINK.item_record_id

group by iii_bib_id)

select 
BIBVIEW.record_num as "brecnum",
BIBPROP.best_title as "title",
BIBPROP.best_author as "author"

from 
item_holds,
sierra_view.bib_view BIBVIEW,
sierra_view.bib_record_property BIBPROP

where 
BIBVIEW.id = item_holds.iii_bib_id
and BIBPROP.bib_record_id = item_holds.iii_bib_id
and item_holds.availableitems > 0
;
