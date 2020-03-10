with 

duplicate_content as (
select ARRAY_AGG( RECORD_num) as record_num_array , content 
from 
sierra_view.subfield_view 
where marc_tag = '856'
and tag = 'u' 
and content ilike '%freading%'
group by content
having count(*) > 1
),
duplicate_bibs as (
select row_number()  over ( partition by content order by content) as row,
 d.content, bib_view.bcode2 as mat_type,  bib_view.*   from 
sierra_view.bib_view , duplicate_content D
where bib_view.record_num = any (D.record_num_array)
)
select 
* from duplicate_bibs;
--  string_agg( '"b' || record_num || '"', ', ') from duplicate_bibs where row = 2;