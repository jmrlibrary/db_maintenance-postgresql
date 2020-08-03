with bibs_without_pdv as (select * from 

sierra_view.bib_view B left join
sierra_view.subfield_view S
on s.record_id = b.id
and 
 s.marc_tag = '049'
and substring(lower(s.content), 1, 3) = lower('PDV')


where marc_tag is null

),




items_for_nodc as (
select * from sierra_view.item_view i

 left join
sierra_view.subfield_view S
on s.record_id = i.id

where substring(i.location_code, 1, 1) = 'n'
and (s.field_type_code = 'x' and s.content = 'Baker&Taylor')
 
)

select * from bibs_without_pdv b,
items_for_nodc i,
sierra_view.bib_record_item_record_link l

where l.item_record_id = i.id
and l.bib_record_id = b.id

;



