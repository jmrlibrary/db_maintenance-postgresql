select
-- *

string_agg ( irecnum, ', ')

from
  (
    select
       '"i' || item_view.record_num || '"' as irecnum, 
       max(item_view.last_checkout_gmt) as checkout,
        max(item_view.last_checkin_gmt) as checkin,
      max (
      -- case statement to handle not-dates at beginning of field
case 
	when 
		-- INT NOTE, used for claims returned
		varfield_view.varfield_type_code = 'z'
		and varfield_view.field_content ~ '... ... \d\d \d\d\d\d:.+' 
	then
		substring(varfield_view.field_content, 1, 15) :: date

	 when
		-- RESER NOTE, used for missing
		varfield_view.varfield_type_code = 'r'
		and varfield_view.field_content ~ 'Missing\s\w+\s\d\d\d\d'
	then
		(substring(varfield_view.field_content, 9, 3) || ' 01 2019' ) :: date

	 else null

 end

        
      ) as max_date
    from
      sierra_view.item_view
      left join sierra_view.varfield_view on item_view.id = varfield_view.record_id
    where
      varfield_view.varfield_type_code in (
       'x' -- 'INT NOTE'
       , 'r' -- 'RESER NOTE'
       )
      and (
      varfield_view.field_content ~ '... ... \d\d \d\d\d\d: Claimed returned' 
      or varfield_view.field_content ~ 'Missing\s\w+\s\d\d\d\d'
      )
      
      and item_view.item_status_code in (
      'z' -- CLAIMS RETURNED
      , 'm' -- MISSING
      )
  --   and varfield_view.field_content  ilike '%claimed returned%'

    group by
      irecnum
  ) sub1
where
  max_date <= now() - interval '1 year'
  and checkout <= now() - interval '1 year'
  and checkin <= now() - interval '1 year'
 --order by
  -- max_date desc;