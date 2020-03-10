with ils_maint as (
  select
    'i' || item_view.record_num as irecnum,
    item_view.record_num as record_num,
    item_view.item_status_code as status_code,
    max (
      case
        when varfield_view.field_content ~ '... ... \d\d \d\d\d\d:.+' then substring(varfield_view.field_content, 1, 15) :: date
        else null
      end
    ) as reserv_note_date,
    max(RM.record_last_updated_gmt) as record_last_updated_date,
    max(RM.previous_last_updated_gmt) as previous_last_updated_date,
    max(Item_view.icode2) as icode2
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
      'o',
      -- LIB USE ONLY
      'n'
    )
    and item_view.itype_code_num not in (100)
  group by
    irecnum,
    item_view.record_num,
    item_status_code
),
billed as (
  select
    IV.id,
    IV.record_num,
    IV.icode2,
    C.overdue_gmt
  from sierra_view.item_view IV
  left join sierra_view.checkout C on IV.id = C.item_record_id
  where
    IV.item_status_code = 'n'
) -- deletions and checks
select
  '(m, z, $, o) to delete ' || count(*),
  string_agg ('"' || irecnum || '"', ', ') as all,
  string_agg (
    case
      when status_code in ('m', 'z') then '"' || irecnum || '"'
      else null
    end,
    ', '
  ) as check_first,
  string_agg (
    case
      when status_code not in ('m', 'z') then '"' || irecnum || '"'
      else null
    end,
    ', '
  ) as immediately
from ils_maint
where
  reserv_note_date <= now() - interval '1 year'
UNION
select
  '(m, z, $, o) to unsuppress ' || count(*),
  string_agg ('"' || irecnum || '"', ', '),
  '',
  ''
from ils_maint
where
  reserv_note_date > now() - interval '1 year'
  and icode2 = 'n'
  and status_code != 'n'
union
  -- unsuppress those
  -- billed within last year
  -- but suppressed
select
  'billed to unsuppress ' || count (billed.id),
  string_agg('"i' || billed.record_num || '"', ', '),
  '',
  ''
from billed
where
  billed.overdue_gmt > now() - interval '1 year'
  and billed.icode2 = 'n'
union
  -- suppress those
  -- billed more than a year ago
  -- and unsuppressed
select
  'billed to suppress ' || count(billed.id),
  string_agg('"i' || billed.record_num || '"', ', '),
  '',
  ''
from billed
where
  billed.overdue_gmt <= now() - interval '1 year'
  and billed.icode2 != 'n';