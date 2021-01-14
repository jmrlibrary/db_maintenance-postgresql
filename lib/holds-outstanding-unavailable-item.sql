
-- table for
-- holds on items
-- where items are ...

-- remember :
-- this pre-filters ptype 18 (so holds from 
-- collection development, snags, branch cards
-- won't show up)
with itemholds as (

select 
HOLDS.record_id as hrecid,
HOLDS.id as hrecnum,
ITEMVIEW.record_num as irecnum,
HOLDS.record_id as irecid,
HOLDS.patron_record_id as precid,
HOLDS.pickup_location_code as holdloc,
ITEMVIEW.item_status_code as "istatuscode",
(ITEMVIEW.barcode) as "barcode",
  (ITEMVIEW.location_code) as "loc",
    (ITEMVIEW.itype_code_num) as "itype",
      (ITEMVIEW.last_checkout_gmt) as "lastcheckout",
      HOLDS.placed_GMT as "holdplaced"

from 
sierra_view.hold HOLDS,
sierra_view.item_view ITEMVIEW

where
HOLDS.record_id = ITEMVIEW.id
and ITEMVIEW.item_status_code not in ('-', '!', 't')
and ITEMVIEW.itype_code_num not in (100)

), 

iteminfo as (

select
itemholds.* ,
vf.field_content as reservenote

from itemholds

-- left join in order to grab holds
-- even on items missing but without reserve note
left join sierra_view.varfield vf
on vf.record_id = itemholds.irecid
and vf.varfield_type_code = 'r' -- reserve note

-- don't use join if you want to 
-- exclude items, missing, no reserve note
-- with a hold
-- (if they don't have a reserve note, they probably went missing this month)
/**
from itemholds,
sierra_view.varfield vf

where vf.record_id = itemholds.irecid
and vf.varfield_type_code = 'r' -- reserve note
**/

),


circtrans as (

select

iteminfo.*,
CIRC.due_date_gmt as duedate


from iteminfo
left join sierra_view.circ_trans CIRC
on  iteminfo.irecid = CIRC.item_record_id
),

bibinfo as (

select
circtrans.*,
BIBVIEW.record_num as brecnum,
 BRECPROP.best_author as "author",
 BRECPROP.best_title as "title"

 from 
 circtrans,
sierra_view.bib_record_property BRECPROP,
sierra_view.bib_record_item_record_link BIBITEMLINK,
sierra_view.bib_view BIBVIEW

WHERE 
circtrans.irecid = BIBITEMLINK.item_record_id
and BIBITEMLINK.bib_record_id = BRECPROP.bib_record_id
AND BIBITEMLINK.bib_record_id = BIBVIEW.id

), 
patroninfo as (
select 
bibinfo.*,
PATRONVIEW.record_num as precnum,
PATRONVIEW.ptype_code as pcode


 from bibinfo,
 sierra_view.patron_view PATRONVIEW

 where bibinfo.precid = PATRONVIEW.id

 -- eliminate institution holds
 and PATRONVIEW.ptype_code != 18
)



select * from patroninfo
ORDER BY 
brecnum;
