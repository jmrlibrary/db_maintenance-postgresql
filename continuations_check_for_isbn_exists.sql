--
-- maintained on scooter at  /home/collspec/projects/staff-portal/sprint-server/src/db/queries/collection/suggestions/continuations_isn_match.sql
--

-- use 
-- ="('" & E2 & "'), " 
-- on spreadsheet to get values


drop  table  if exists  possible_matches;
create temp table possible_matches (identifier varchar);
insert into possible_matches values ('9781641433921'), 
('9781974708208');

with uniques as (
select distinct(identifier) from possible_matches),

-- select * from possible_matches;

 record_num_identifier as (
  SELECT
    SV.record_num as brecnum,
    SV.content as content,
    PM.identifier as identifier
  FROM uniques PM left join sierra_view.subfield_view SV 
     on PM.identifier = substring(SV.content, '\S+')
     and SV.tag  = 'a'
    -- subfield tag a = where isbn is kept
     -- marc tags for standard number
    and marc_tag in('020', '024', '028')
    and field_type_code = 'i' -- field type code for standard number
    and record_type_code = 'b' -- bib record type
)
select identifier::bigint from record_num_identifier where content is null;