with 

duplicate_content as (
select content 
from 
sierra_view.subfield_view 
where marc_tag = '856'
and tag = 'u' 
and content ilike '%overdrive%'
group by content
having count(*) > 1
),

duplicate_bibs as (
select subfield_view.* from 
sierra_view.subfield_view , duplicate_content D
where subfield_view.content = D.content
)
select * from duplicate_bibs order by content;