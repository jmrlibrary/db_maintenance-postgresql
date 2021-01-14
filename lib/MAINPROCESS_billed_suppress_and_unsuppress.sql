with billed as (
select 
IV.id, 
IV.record_num,
IV.icode2,
 C.overdue_gmt

from sierra_view.item_view IV
left join sierra_view.checkout C
on IV.id = C.item_record_id
where IV.item_status_code = 'n'

)

-- unsuppress those 
-- billed within last year
 -- but suppressed
select 'unsuppress', count (billed.id), string_agg('"i' || billed.record_num || '"', ', ') 
from 
billed
where
 billed.overdue_gmt > now() - interval '1 year'
and billed.icode2 = 'n'

union

-- suppress those
-- billed more than a year ago
-- and unsuppressed
select 'suppress', count(billed.id), string_agg('"i' || billed.record_num || '"', ', ') 
from 
billed
where
billed.overdue_gmt <= now() - interval '1 year'
and billed.icode2 != 'n';