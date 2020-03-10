with duplicate_overdrive_bibs as (
select max('b' || record_num) as brecnum from sierra_view.subfield_view 
where marc_tag = '856'
and tag = 'u' 
and content ilike '%overdrive%'
group by content
having count(*) > 1)
select string_agg( '"' || brecnum || '"', ', ') from duplicate_overdrive_bibs;