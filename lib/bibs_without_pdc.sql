with bibs_without_pdv as (select * from 

sierra_view.bib_view B left join
sierra_view.subfield_view S
on s.record_id = b.id
and 
 s.marc_tag = '049'
and lower(s.content) = lower('PDV')


where marc_tag is null

;)

