with bibs_with_holds as (

select bibview.id as brecid

from sierra_view.bib_view BIBVIEW,
sierra_view.hold HOLDS


where 
bibview.id = HOLDS.record_id
group by 1
), bibs_with_available_items as (

select BWH.brecid as brecid
 
from bibs_with_holds BWH,
sierra_view.bib_record_item_record_link BILINK,
sierra_view.item_view ITEMVIEW

where 
BWH.brecid = BILINK.bib_record_id
and BILINK.item_record_id = ITEMVIEW.id
and ITEMVIEW.item_status_code in ('-', 't', '!')
and ITEMVIEW.icode2 != 'n'
and ITEMVIEW.itype_code_num not in (100, 1, 99, 76, 70, 78, 77, 40)

group by 1
), bibs_without_available_items as (

select bwh.brecid as brecid
--bwai.brecid as b

from 
bibs_with_holds BWH
left join 
bibs_with_available_items BWAI
on BWAI.brecid = BWH.brecid

where bwai.brecid is null

group by 1)

select BIBVIEW.*,
BIBVIEW.record_num as brecnum,
HOLDS.placed_gmt as holdplaced,
HOLDS.id as hrecnum,
HOLDS.PATRON_RECORD_ID as precid,
substring(id2reckey(HOLDS.PATRON_RECORD_ID), 2) as precnum,
HOLDS.pickup_location_code 

 from bibs_without_available_items BWAI, 
sierra_view.bib_view BIBVIEW,
sierra_view.hold HOLDS

where 
BIBVIEW.id = BWAI.brecid and
BWAI.brecid = holds.record_id and
HOLDS.patron_records_display_order = 0

order by holdplaced

;