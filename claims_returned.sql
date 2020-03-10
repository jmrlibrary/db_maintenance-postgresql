select
*
from
  (
    select
       '"i' || item_view.record_num || '"' as irecnum,
      max (
        substring(varfield_view.field_content, 1, 15) :: date
      ) as max_date
    from
      sierra_view.item_view
      left join sierra_view.varfield_view on item_view.id = varfield_view.record_id
    where
      varfield_view.varfield_type_code = 'x'
      and varfield_view.field_content ~ '... ... \d\d \d\d\d\d:.+'
      and item_view.item_status_code in ('z')
      and varfield_view.field_content  not ilike '%claimed returned%'
    group by
      irecnum
  ) sub1
where
  max_date <= now() - interval '1 year'
 order by
   max_date desc;