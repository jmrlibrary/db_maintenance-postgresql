select 

concat ('b', BIBVIEW.record_num, 'a') as "brecnum",
max(BIBVIEW.bcode3) as "bcode3",
max(BIBPROP.best_title) as "title",
max(BIBPROP.best_author) as "author",
min(HOLDS.placed_gmt) as "holdplaced",
count (case when ITEMVIEW.item_status_code in ('-', 't', '!') then ITEMVIEW.id end ) as "availableitems",
count (ITEMVIEW.id) as "anyitems",
-- max (PATVIEW.barcode) as "pbarcode",
-- max (trim(concat(PATNAME.first_name, ' ' , PATNAME.last_name))) as "pname",
max(HOLDS.pickup_location_code) as "pickuplocationcode",
max( ITEMVIEW.ITEM_STATUS_CODE) as "istatuscode",
max(ITEMVIEW.location_code) as "location",
max(substring(itemview.location_code, 1, 1)) as "branchcode",

-- WILL HAVE TO USE THIS AS A HIDDEN FIELD, ESSENTIALLY
-- FOR QUERIES
 max(HOLDS.patron_record_id) as "iii_precid"

from sierra_view.bib_view BIBVIEW

/*
An inner join here would only capture bibs connected to items
(difference is about 192k vs. 245k bib records)
*/
left join sierra_view.bib_record_item_record_link BILINK
on BIBVIEW.ID = BILINK.bib_record_id

left join sierra_view.item_view ITEMVIEW
on BILINK.item_record_id = ITEMVIEW.id

join sierra_view.hold HOLDS
on BIBVIEW.ID = HOLDS.record_id

/*
I should also grab all the holds on it, too (might be more than one)
*/

/*
This search is like ... 30 times faster without joining to the patron table
*/
/*
join sierra_view.patron_view PATVIEW
on HOLDS.patron_record_id = PATVIEW.id

join sierra_view.patron_record_fullname PATNAME
on PATVIEW.ID = PATNAME.patron_record_id
*/
join sierra_view.bib_record_property BIBPROP
on BIBVIEW.ID = BIBPROP.bib_record_id


where 
--ITEMVIEW.item_status_code in ('-', 't', '!')
HOLDS.patron_records_display_order = 0 
group by BIBVIEW.record_num

having 
count (case when ITEMVIEW.item_status_code in ('-', 't', '!') then ITEMVIEW.id end ) = 0
and
count (ITEMVIEW.id) > 0

order by max(substring(ITEMVIEW.location_code, 1, 1)), min(HOLDS.placed_gmt)

;