--
-- maintained on scooter at  /home/collspec/projects/staff-portal/sprint-server/src/db/queries/collection/suggestions/continuations_isn_match.sql
--

-- use 
-- ="('" & M2 & "'), " 
-- on spreadsheet to get values


drop  table  if exists  possible_matches;
create temp table possible_matches (identifier varchar);
insert into possible_matches values 
('9780802157997'), 
('9781335924827'), 
('9781250764744'), 
('9781542019859'), 
('9781524749361'), 
('9781250187420'), 
('9781984818751'), 
('9780399178542'), 
('9780593132852'), 
('9781982108847'), 
('9780593087916'), 
('9781643854663'), 
('9780063031852'), 
('9780593193013'), 
('9780735224650'), 
('9781984818461'), 
('9780593188323'), 
('9780316479257'), 
('9780316541619'), 
('9780385545969'), 
('9780316435581'), 
('9781982104382');

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