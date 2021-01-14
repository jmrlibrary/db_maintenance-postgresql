with 
elapsed as (
select interval '18 months' as time
),

to_delete as (
select 
IV.id as item_view_id, 
IV.record_num,
IV.icode2,
IV.last_checkin_gmt as last_checkin_date,
IV.last_checkout_gmt as last_checkout_date,
IV.item_status_code,
IV.year_to_date_checkout_total as ytdcirc,
IV.last_year_to_date_checkout_total as lyrcirc,
C.id as checkout_id,
 C.overdue_gmt as overdue_date,
 C.checkout_gmt as checkout_date,
 C.due_gmt as due_date

from sierra_view.item_view IV
left join sierra_view.checkout C
on IV.id = C.item_record_id

where 
IV.item_status_code in ('z', 'm', 'o', '$')

)
-- select * from to_delete;
select 'z, m, o, $ to delete',
count(*),
string_agg( '"i' || record_num || '"', ', ')

 from to_delete where 
last_checkin_date < now() -  (select time from elapsed)
and last_checkout_date < now() -  (select time from elapsed)
and last_checkin_date is not null
and last_checkout_date is not null
and ytdcirc + lyrcirc = 0
and (overdue_date < now() -  (select time from elapsed) or overdue_date is null)
and (due_date  < now() -  (select time from elapsed) or due_date is null)
and (checkout_date < now() -  (select time from elapsed) or  checkout_date is null);
