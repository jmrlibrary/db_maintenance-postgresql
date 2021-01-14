
/**

TODO:
Show # of holds
quantity (# of copies)
(ratio? and preflagging for higher?)

*** NOW MAINTAINED ON SCOOTER

*/

with btea_orders as (

select 
ov.id, 
ov.record_num ,

sum(
case  when sv.content ilike '%order%' 
then 1
else 0
end) as sent_order_count

from sierra_view.order_view ov
left join sierra_view.subfield_view sv on 
	sv.record_id = ov.id

where ov.vendor_record_code = 'btea'
-- and sv.tag = 'b'
and sv.field_type_code = 'b'

group by ov.id, ov.record_num

)
, unsent as (
select * from btea_orders where sent_order_count = 0)

, with_holds as (

select unsent.id from 
unsent,
 sierra_view.bib_record_order_record_link link, 
 sierra_view.hold h

 where unsent.id = link.order_record_id
 and link.bib_record_id = h.record_id

 group by 1

) 

select ov.* 
from with_holds w, 
sierra_view.order_view ov 

where w.id = ov.id

order by record_num;