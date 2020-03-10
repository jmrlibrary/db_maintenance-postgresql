select 

-- concat (ITEMVIEW.record_type_code, ITEMVIEW.record_num, 'a') as "oRecnum"
HOLDS.ID,
max(VARFIELDS.field_content) as "callnum",
max(ITEMVIEW.barcode) as "barcode",
  max(ITEMVIEW.location_code) as "loc",
  max(BRECPROP.best_author) as "author",
  max(BRECPROP.best_title) as "title"

FROM 

sierra_view.hold HOLDS

join sierra_view.item_view ITEMVIEW
on HOLDS.record_id = ITEMVIEW.id

join sierra_view.bib_record_item_record_link BIBITEMLINK
on ITEMVIEW.id = BIBITEMLINK.item_record_id

join sierra_view.bib_record_property BRECPROP
on BIBITEMLINK.bib_record_id = BRECPROP.bib_record_id

join sierra_view.varfield_view VARFIELDS
on BIBITEMLINK.bib_record_id = VARFIELDS.record_id

where VARFIELDS.marc_tag in ('092', '082')
AND ITEMVIEW.item_status_code = '-'
AND ITEMVIEW.is_suppressed = 'f'

-- check for branch ?
-- AND SUBSTR(ITEMVIEW.location_code,1,1) = 'r'

group by 
HOLDS.id

order by
"loc"
;