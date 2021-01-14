-- i'M NOT SURE I KNOW WHAT I'M TRYING TO GET THIS ONE TO RETURN

select 

count (ITEMVIEW.id) as "itemcount",
max (CONCAT(ITEMVIEW.record_type_code, ITEMVIEW.record_num,  'a')) as "irecnum",
max (CONCAT(BIBVIEW.record_type_code, BIBVIEW.record_num,  'a')) as "brecnum"

from sierra_view.bib_record_item_record_link BIBITEMLINK

left JOIN sierra_view.item_view ITEMVIEW
on BIBITEMLINK.item_record_id = ITEMVIEW.id

left join sierra_view.bib_view BIBVIEW
on BIBITEMLINK.bib_record_id = BIBVIEW.id

WHERE 
ITEMVIEW.item_status_code IN ('-', 't', '!')
AND BIBVIEW.bcode3 != 'n'
AND ITEMVIEW.itype_code_num NOT IN (60, 50, 62, 54, 53, 1, 0, 25, 26, 27, 0, 70, 72, 100, 77, 99)
AND ITEMVIEW.location_code NOT IN ('apc', 'cpc', 'gpc', 'lpc', 'mjpc', 'mpc', 'npc', 'rpc', 'spc')

GROUP BY
BIBITEMLINK.bib_record_id

having count (ITEMVIEW.id) = 0

limit 100;