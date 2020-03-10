

-- get all the scanned barcodes
with first_loc as (

select *  from sierra_view.item_view IV, sierra_view.subfield_view SV
 where barcode in ('31743303525222', '31743308404662', '31743308402161', '31743306094895', '31743308754413')
 and IV.id = SV.record_id
 and SV.tag = 'a'
 and SV.field_type_code = 'c'
 and SV.record_type_code = 'i'
),

-- get the tuple with the lowest call number
 min_call as (
select * from first_loc order by first_loc.content asc limit 1

),

-- get the tuple with the highest call number
max_call as (
select * from first_loc order by first_loc.content desc limit 1

)

-- select * from max_call
-- union select * from min_call

select    case when (inventory_gmt is null or inventory_gmt < (now() - interval '2 days') ::date )
   and due_gmt is null
   and item_status_code = '-'
   then true else null end as needs_inva_date
, location_code, content, barcode, inventory_gmt, item_status_code, due_gmt, 

*  
from sierra_view.item_view IV join sierra_view.subfield_view SV on IV.id = sv.record_id
left join sierra_view.checkout C on C.item_record_id = iv.id

where sv.content >= (select content from min_call)
and sv.content <= (select content from max_call)
and iv.location_code = 'rya' 

order by content;
