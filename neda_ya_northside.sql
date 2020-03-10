


-- select distinct(call_number_prefix), count(*) from sierra_view.bib_record_call_number_prefix group by call_number_prefix;

with a as (
select

location_code, 
IV.id, IV.record_num, IV.item_status_code,  IV.itype_code_num, IV.inventory_gmt , case when inventory_gmt::date = now()::date then 'true' else '' end as invent_today, SV.content
 
from  sierra_view.item_view IV , sierra_view.subfield_view SV 
where  location_code = 'rya' 
and IV.id = sv.record_id
and sv.field_type_code = 'c'
and IV.itype_code_num not in (24, 74, 70, 64, 61, 57, 69, 82, 59)
-- and inventory_gmt::date = now()::date


order by 
 iv.itype_code_num,
 sv.content asc
 )
 select a.*, c.due_gmt from a left join sierra_view.checkout C
 on c.item_record_id = a.id;