
with a as (


select * from (values 
('9780735213616')



) 

as b(v)
)

select * from a left join sierra_view.subfield s

on s.content like a.v
   and
-- record_type_code = 'b' and 
field_type_code = 'i' -- standard number
-- and     marc_tag in ('020', '028', '024')
and marc_tag = '020'
     and tag = 'a' -- subfield identifier tag
     ;