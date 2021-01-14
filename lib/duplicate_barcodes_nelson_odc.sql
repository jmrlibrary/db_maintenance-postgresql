with b as (
select barcode, count(*) 

 from sierra_view.item_record_property 

 group by barcode
 ), c as( select barcode from b where count > 1 and barcode is not null and barcode != '')

, one_bib_or_two as (
 select i.barcode, count(*) from c, sierra_view.item_record_property i , sierra_view.bib_record_item_record_link link

 where 
 i.item_record_id = link.item_record_id and 

 i.barcode = c.barcode

 group by i.barcode, link.bib_record_id

 order by count

 )

 select o.barcode, o.count, 
sum (
case when i.inventory_gmt is null
then 0
else 1
end) as inva_count

  from one_bib_or_two o, sierra_view.item_view i

 where o.barcode = i.barcode

 group by o.barcode, o.count 

 having count = 2;