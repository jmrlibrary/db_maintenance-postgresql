/*
Get possible 
*/

with q as (
   select regexp_split_to_table(trim('Matar, Hisham'), E'[,.\\s]+') as s
),
r as 
( select array  (select '%' || s || '%' from q )  as t),
s as (
select * from sierra_view.subfield_view
where 
record_type_code = 'b' 
and tag = 'a' 
and marc_tag in (100::varchar, 700::varchar)),

possible_bibs as 
(
select 
record_id,
record_num,
marc_tag,
content

from s , r

where 

s.content ilike all ( r.t)
)

-- select BV.* 
-- from possible_bibs P, sierra_view.bib_view BV
-- where P.record_num = BV.record_num;

select 
P.record_num as brecnum,
P.content as author,
I.record_num as irecnum,
I.barcode as barcode,
I.icode2,
I.icode1,
I.itype_code_num,
I.location_code,
I.item_status_code,
I.last_checkin_gmt::date,
I.last_checkout_gmt::date,
I.record_creation_date_gmt ::date as item_create_date,
age( I.record_creation_date_gmt) as elapsed_time,
--I.renewal_total,
I.checkout_total as total_checkout,
I.last_year_to_date_checkout_total as lyr_checkout,
I.year_to_date_checkout_total as ytd_checkout,

substring(I.location_code, 1, 1) as branch_code,
B.title,
B.bcode2 as mat_type,
b.bcode3


from possible_bibs P,
sierra_view.bib_record_item_record_link L,
sierra_view.item_view I,
sierra_view.bib_view B

where 
P.record_id = L.bib_record_id
and L.item_record_id = I.id
and L.bib_record_id = B.id

order by content, I.year_to_date_checkout_total +I.last_year_to_date_checkout_total  desc;