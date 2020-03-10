/*

ILS_MAINT is a CTE (common table expression)
	syntax : with <name> as ( <query> )

->>>
It joins the item_view, varfield_view, and record_metadata tables.

->>>
It 'returns' or gives us back the following information for each eligible item
	- the item record number ('i1234567') that you see in the catalog with a 'check digit' ('i1234567a')
	- the item status code .possible values include: 
		'z' CLAIMS RETURNED
		'm' MISSING
		'$' LOST AND PAID
		'o' LIB USE ONLY
		'n' BILLED
	- the MOST RECENT date that appears in the INT NOTE or RESER NOTE field (see below)
	- the MOST RECENT date the item record was last updated
	- the MOST RECENT date the item record was penultimately updated
	- the ICODE2 item field ('n' suppressed, '-' not suppressed)

->>>
It filters results on the following conditions :

the item status code is either 
      'z' CLAIMS RETURNED
      'm' MISSING
      '$' LOST AND PAID
      'o' LIB USE ONLY
      'n' BILLED

the varfield type code is INT NOTE ('x') or RESER NOTE ('r')
	-- these correspond to the INT NOTE or RESER NOTE seen
	in an item record

the content for the INT NOTE or RESER NOTE corresponds to a 
'regular expression' of the format '... ... \d\d \d\d\d\d:'
	. = a single character
	\d = a single digit
	: = literal colon character (:)
What we're looking for is a note that looks like
	'Tue Nov 5 2019: <detail>'

INT NOTEs of this type are automatically populated by the system, e.g.
	item_type_code: 'n' (Billed) 
	INT NOTE	Sat May 04 2019: Bill $15.99, lost by .p12012440

	item_type_code: 'z' (Lost and paid)
	INT NOTE	Thu Oct 18 2018: Bill $28.95, lost by .p1195551x
	INT NOTE	Thu Oct 18 2018: Paid $28.95 and lost by p1195551x

RESER NOTEs of this type are manually created by Collection Management.
	RESER NOTE 	Tue Nov 5 2019: Lostandpaid
	

BILLED is our second CTE (common table expression)
	for each item that is billed (item status code = 'n'),
	this CTE returns
		the iii item id (used by the system to match item records with detailed info about them)
		the item record number ( e.g. 'i1234567')
		the item icode2 ('n' suppressed or '-' available)
		the item overdue date 
			(seen on the item record as ODUE DATE.
			the system describes this as the date that the last 'billed' letter
			was sent to a patron.)

	This CTE is used to identify any item records that have been billed.
	We will use this search to find out 
		which billed items to suppress
			(those with an ODUE DATE over a year ago to date)
		which billed items to unsuppress
			(those with an ODUE DATE more recent than a year)
	***
	BILLED ITEMS DO NOT GET MARKED FOR DELETION during this process.
	***

*/
		
/*
ILS_MAINT CTE
*/
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

/*
BILLED CTE
*/
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
) 

/*
MAIN QUERY
*/
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

/*
FIRST UNION STATEMENT
*/
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
  
/*
SECOND UNION STATEMENT
*/
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

  /*
THIRD UNION STATEMENT
*/
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