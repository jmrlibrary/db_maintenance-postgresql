
with a as (


select * from (values ('9780972394642%'), ('9780062324153%')) as b(v)
)

select * from a left join sierra_view.subfield_view s

on s.content like a.v
   and
record_type_code = 'b' and 
field_type_code = 'i'
and     marc_tag in ('020', '028', '024')
     and tag = 'a'
     ;