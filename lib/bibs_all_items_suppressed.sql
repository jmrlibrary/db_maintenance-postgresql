-- this will still show kits and backpacks, which I don't think should be suppressed
--  at the bib level?

with a as (
select 
b.record_num,
b.bcode3,
sum( case when i.icode2 = 'n' then 1 else 0 end) as suppressed, 
sum (case when icode2 != 'n' then 1 else 0 end) as not_suppressed,
count(*)

from 
sierra_view.bib_view b, 
sierra_view.bib_record_item_record_link l, 
sierra_view.item_view i

where 
l.item_record_id = i.id
and l.bib_record_id = b.id
and b.bcode2 != 'k'

group by b.record_num, b.bcode3
), b as (
select * from a 
where suppressed = count 
and bcode3 != 'n')

select string_agg('"b' || record_num || '"' , ', ') from b
