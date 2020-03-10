select
  
  string_agg ( '"' || irecnum || '"' , ', ') as eventually_delete,
  string_agg (
 case when status_code in ('m', 'z') then '"' || irecnum || '"'
 else null end, ', ') as check_then_delete,
   string_agg (
 case when status_code not in ('m', 'z') then '"' || irecnum || '"'
 else null end, ', ') as nocheck_delete
from (
    select
      'i' || item_view.record_num as irecnum,
      max(item_view.last_checkout_gmt) as checkout,
      max(item_view.last_checkin_gmt) as checkin,
      max (item_view.item_status_code) as status_code,
      max (
        case
          when varfield_view.field_content ~ '... ... \d\d \d\d\d\d:.+' then substring(varfield_view.field_content, 1, 15) :: date
          else null
        end
      ) as reserv_note_date,
      max(RM.record_last_updated_gmt) as record_last_updated_date,
      max(RM.previous_last_updated_gmt) as previous_last_updated_date
    from sierra_view.item_view
    left join sierra_view.varfield_view on item_view.id = varfield_view.record_id
    join sierra_view.record_metadata RM on RM.record_type_code = 'i'
      and item_view.record_num = RM.record_num
    where
      varfield_view.varfield_type_code in (
        'x',
        -- 'INT NOTE'
        'r' -- 'RESER NOTE'
      )
      and (
        varfield_view.field_content ~ '... ... \d\d \d\d\d\d:'
      )
      and item_view.item_status_code in (
        'z',
        -- CLAIMS RETURNED
        'm',
        -- MISSING
        '$',
        -- LOST AND PAID
        'o' -- LIB USE ONLY
      )
    group by
      irecnum
  ) sub1
where
  reserv_note_date <= now() - interval '1 year'
  and checkout <= now() - interval '1 year'
  and checkin <= now() - interval '1 year'
-- order by
-- status_code,
--    reserv_note_date desc
;