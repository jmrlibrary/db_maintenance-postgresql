drop   table  if exists overdrive_isns;
create temp table overdrive_isns(isn bigint)  ;
insert into overdrive_isns values (439391377),

(9781524708665);


select * from overdrive_isns oi
left join sierra_view.subfield_view sv
on trim(oi.isn::varchar) = substring(trim(sv.content), 1, 13) 

and tag = 'a' 
and marc_tag in ('020', '028', '024') 
and record_type_code = 'b'

-- where content is null

order by content, isn
;
