select h.is_frozen
-- h.expires_gmt::date as 
--pickup_date,
,
 count(*)
from sierra_view.patron_view PV 
 join sierra_view.hold H
 on pv.id = h.patron_record_id 
 group by
 --  h.expires_gmt::date
 h.is_frozen
--ah
 order by pickup_date;