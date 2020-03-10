

with first_loc as (

select *  from sierra_view.item_view IV, sierra_view.subfield_view SV
 where barcode in ('31743303525222', '31743308404662', '31743308402161', '31743306094895')
 and IV.id = SV.record_id
 and SV.tag = 'a'
 and SV.field_type_code = 'c'
 and SV.record_type_code = 'i'
),

 min_call as (

select * from first_loc order by first_loc.content asc limit 1

),

max_call as (

select * from first_loc order by first_loc.content desc limit 1

)

-- select * from max_call
-- union select * from min_call

select *  from sierra_view.item_view IV, sierra_view.subfield_view SV
where sv.content >= (select content from min_call limit 1)
and sv.content <= (select content from max_call limit 1)
and iv.location_code = 'rms'

limit 10;
